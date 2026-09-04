<!--
SPDX-FileCopyrightText: 2025 Bram Wesselo

SPDX-License-Identifier: CC-BY-SA-4.0
-->

### Introduction

This page specifies how FHIR-based **event notifications** are exchanged between organizations in the Dutch healthcare ecosystem. It describes a generic transport layer that other Implementation Guides and use cases (e.g. [Notified Pull](./notified-pull.html)) build upon: a sending organization signals to a receiving organization that something it cares about has happened, and the receiver pulls the current state from the sender's FHIR endpoint.

The framework is based on the [FHIR Subscription Framework](https://build.fhir.org/subscriptions.html), implemented in FHIR R4 via the [Subscriptions R5 Backport for R4](https://hl7.org/fhir/uv/subscriptions-backport/). It uses three core resources: `SubscriptionTopic` (defining events and triggers), `Subscription` (describing the receiver's interest in notifications), and notification `Bundle`s (carrying `event-notification`, `handshake-notification` or `heartbeat-notification`). Clients request notifications based on specific topics, and servers send them over a configured channel.

Key design principles include:

- **International standards:** the solution is based on the HL7 FHIR Subscription Framework, lowering the bar for international (European) data exchange and adoption by internationally operating software vendors.
- **Out-of-band (server-managed) style:** for some SubscriptionTopics, the subscription is created by the sender (the Subscription Server), using the endpoint of the receiver that was communicated 'out-of-band' (using [GF Addressing](./care-services.html#endpoint)). A client-initiated subscription MAY be supported. 
- **Thin notifications, authoritative source:** notifications carry no clinical content. The sender remains the source of truth; the receiver pulls the referenced resource from the sender's FHIR endpoint to obtain the current state.

### Solution overview

Here is a brief overview of the processes that are involved:

1. At the sending organization (the [Subscription Server](#subscription-server)) a `Subscription` is registered for the receiving organization (the [Subscription Client](#subscription-client)) against an agreed `SubscriptionTopic`. How this `Subscription` is created is use-case defined (in-band or out-of-band); see [Subscription](#subscription).
2. After registration, the Subscription Server sends a `handshake-notification` to confirm the channel and updates `Subscription.status` accordingly.
3. Whenever an event matches the topic and filter, the Subscription Server sends an `event-notification` Bundle to the receiver, with a monotonically increasing `event-number`.
4. At predefined intervals the Subscription Server sends a `heartbeat-notification` so the receiver can detect channel outages.
5. The Subscription Client consumes notifications, detects missed events using `event-number`, and uses the `$event` and `$status` operations on the sender to catch up or query state.
6. The Subscription Client may fetch the resource that were mentioned in the notification bundle.



### Components (actors)

#### Subscription Server

The Subscription Server runs at the **sending** party and is responsible for managing subscriptions and delivering notifications. It MUST:

- create `Subscription` resources for the agreed (Out-of-band Managed) `SubscriptionTopic`(s). 
- send `handshake-notification` Bundles when `Subscription.status` is `requested` (with retries) and update `Subscription.status` accordingly;
- send `heartbeat-notification` Bundles at predefined intervals (with retries) and update `Subscription.status` accordingly;
- send `event-notification` Bundles, incrementing `event-number` in a concurrent-safe way;
- support the `Subscription` resource so clients can query state and catch up on missed events:
    - support the `$status` and `$event` operations;
    - support the `read` and `search` interaction with search parameters `status`, `criteria`, `channel.endpoint`, `channel.type` and `channel.payload`;

The Subscription Server MAY support creation of subscriptions by Subscription Clients (In-band Managed Subscriptions).

#### Subscription Client

The Subscription Client runs at the **receiving** party and consumes notifications. It MUST:

- receive notification Bundles at its notification endpoint (and forward/act on them);
- check each notification Bundle to ensure no events were missed, using the highest `event-number` it has successfully processed. Missed notifications are caught up using the sender's `$event` operation;
- check at predefined intervals whether a `heartbeat-notification` was missed. If so, the subscription status is queried using the sender's `$status` operation.

The Subscription Client, being responsible for resolving failures, should also track the subscription's state to highlight and fix any erroneous communication.


### Data models

A brief description of the data models used in this guide:

#### Subscription

A `Subscription` is created at the **sending** organization for a **receiving** organization before any notifications flow. The pattern is a **broad, long-lived Subscription per partner** for a given use-case topic, not a Subscription per case. A single Subscription covers all events that match the topic and filter between the two partners.

How the Subscription is created is **use-case defined**: it MAY be created in-band (the client POSTs a Subscription to the server) or out-of-band.  
For out-of-band managed subscriptions, the receiver's notification endpoint is typically resolved via the addressing function ([Care Services Query Directory](./care-services.html#query-directory)); see the [endpoint discovery example](./care-services.html#use-case-2-endpoint-discovery). An Endpoint capable of receiving notifications is defined by `connectionType = hl7-fhir-rest` and `.payloadType = Subscription` (see [Endpoint profile](./care-services.html#endpoint). 

The server MUST check for an existing Subscription for the client before sending notifications; beyond that, the creation mechanism does not affect runtime behavior.

A Subscription SHALL:

- set `Subscription.status = active` while in use and `off` to retire the channel;
- carry a `SubscriptionTopic` canonical URL on `Subscription.criteria` (using the Backport IG `backport-topic-canonical` extension where the `criteria` element cannot itself hold the canonical) and MAY carry a refining filter using `backport-filter-criteria`;
- set `Subscription.channel.type = rest-hook` with the receiver's notification endpoint;
- set `Subscription.channel.payload = application/fhir+json` and the Backport IG `backport-payload-content` extension to `id-only`.

A [Subscription example](./Subscription-614899b2-5132-488b-8cb8-12a821fceb06.json.html) is in the IG artifacts: a long-lived Subscription at one organization that fires whenever a Task is owned by a partner organization identified by URA.

#### Notification Bundle

Each event matching the `SubscriptionTopic` and filter triggers one notification to the receiver. The notification is a FHIR `Bundle` of type `history` conforming to the Backport IG `backport-subscription-notification` profile. It contains a `Parameters` resource (SubscriptionStatus) conforming to `backport-subscription-status-r4` with at minimum:

- `subscription` — reference to the registered Subscription;
- `status` — `active` or `off`;
- `type` — `event-notification`, `handshake-notification` or `heartbeat-notification`;
- `notification-event.event-number` — monotonically increasing, used by the receiver to detect missed events;
- `notification-event.timestamp` — when the event occurred at the sender;
- `notification-event.focus` — reference to the resource the event is about (e.g. the Task on the sender).

The notification carries **no clinical content**. With `id-only` payload the receiver learns only that a referenced resource has changed and pulls it from the sender's FHIR endpoint to obtain the current state.

A [notification Bundle example](./Bundle-39b97672-5de0-47b3-acf3-e49a3cb8d13a.json.html) and its [SubscriptionStatus Parameters](./Parameters-292d3c72-edc1-4d8a-afaa-d85e19c7f562a.json.html) are in the IG artifacts; together they notify a partner that it is the proposed owner of a Task held at the sender.

#### SubscriptionTopic

A `SubscriptionTopic` defines the events that trigger notifications and the resource shape they apply to. SubscriptionTopics are owned and published per use case; each Implementation Guide that builds on this transport layer is responsible for defining (or referencing) the topics it uses, and for binding them to a canonical URL referenced by `Subscription.criteria`.

### Security

Notification endpoints MUST require mTLS. Authentication and authorization for notifications and for the subsequent pull on the sender's FHIR endpoint follows the [GF Authorization](./authorization.html) specification.

Because notifications use `id-only` payload, the notification Bundle itself contains no clinical content and minimal personal data. The actual resource content is only disclosed when the receiver pulls it from the sender's FHIR endpoint, where the sender re-evaluates authorization at the moment of access.

### Example use cases

#### Use case: notifying a partner of a new Task

A sending organization holds a `Task` that names a partner organization (identified by URA) as its (proposed) `owner`. A long-lived `Subscription` exists at the sender for that partner against a topic that fires when a Task's `owner` matches the partner's URA. When the Task is created, the Subscription Server sends an `event-notification` Bundle to the partner's notification endpoint; the partner reads the Task from the sender to learn what to do next.

The example artifacts for this scenario are the [Subscription](./Subscription-614899b2-5132-488b-8cb8-12a821fceb06.json.html) and the [notification Bundle](./Bundle-39b97672-5de0-47b3-acf3-e49a3cb8d13a.json.html) with its [SubscriptionStatus Parameters](./Parameters-292d3c72-edc1-4d8a-afaa-d85e19c7f562a.json.html).

### Roadmap for Notifications

Potential future enhancements include:

- a registry of nationally agreed `SubscriptionTopic` canonical URLs;
