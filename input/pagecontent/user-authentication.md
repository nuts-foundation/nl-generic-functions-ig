# User authentication

How to authenticate an end user to another party?

Let the user authenticate itself at a trusted identity provider(IDP).

This identity will be presented alongside other attributes to the authorization server of the resource server.

## Requirements

- User should not authenticate/login for every access token request.
- User can work for multiple healthcare organization
- User can have a role specific for a given healthcare organization
- The solution can both be used to authenticate employees (care givers) in their own EHR as it can be used to authenticate to third parties.

## Solution direction

User creates an active session with the IDP by loggin in with a trusted means like DigID or a european wallet. The IDP now knows the user. The login session is initiated from the EHR of the healthcare provider the user is currently working. After authenticating the EHR receives the identity of the user via a id-token or by interacting with the /userinfo endpoin

Then, when the user initiates an interaction with an external care provider, the EHR initates a signing session with the IDP. Ideally the user still has an open session and does not have to login again. The session can also be recreated by providing a refresh token to the IDP.

The user has to answer a quiestion in the form of: "Do you want your identity be shared with CareProvider X?". If the user agrees, the IDP creates a token which contains the identity of the user and the audience of CareProvder X.

The requesting organization sends this token to the AS of CareProvder X which can validate the claim and then issue an access token which cab be used by the client to fetch resources.

## Actors

Relying party
IDP
Signing service
Authentication server
Resource server

create session:

RP -> user: redirct to IDP
user -> IDP: login
idp -> user: redirect back to RP with code
user -> RP: offer code
RP -> IDP: fetch id-token

sign a statement:
RP -> IDP: start signing session
