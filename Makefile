# SPDX-FileCopyrightText: 2025 Roland Groen <roland@headease.nl>
# SPDX-FileCopyrightText: 2025 Steven van der Vegt <github@svandervegt.nl>
#
# SPDX-License-Identifier: EUPL-1.2

builder:
	docker build -t ig-builder .

ig:
	docker run --rm --name=ig-builder \
		-v ./input:/app/input \
		-v ./output:/app/output \
		-v ./ig.ini:/app/ig.ini \
		-v ./sushi-config.yaml:/app/sushi-config.yaml \
		-v ./build-cache:/app/input-cache \
		ig-builder
