## [1.1.18](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.17...v1.1.18) (2025-05-19)


### Bug Fixes

* bump to remove debugging ([f2859b5](https://github.com/billypearson/github-action-ci-lock/commit/f2859b5e8288ff9c63e433614ccb297ae4b79f65))

## [1.1.17](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.16...v1.1.17) (2025-05-19)


### Bug Fixes

* push update to check for existing lock and not allow overwrite of existing locks ([1d70342](https://github.com/billypearson/github-action-ci-lock/commit/1d70342f205b3fa197ca834f60ba5962992a9f25))

## [1.1.16](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.15...v1.1.16) (2025-05-19)


### Bug Fixes

* remove the ensure the lock file matches post-rebase ([8bf1e65](https://github.com/billypearson/github-action-ci-lock/commit/8bf1e65dda7f33f2dce2274bb09bb795f489005a))

## [1.1.15](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.14...v1.1.15) (2025-05-19)


### Bug Fixes

* push change to attempt incr ([19670dc](https://github.com/billypearson/github-action-ci-lock/commit/19670dcf09a601463e4a2f48d5f5a27eb6eeed51))

## [1.1.14](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.13...v1.1.14) (2025-05-19)


### Bug Fixes

* push update to add in timeout for max attempts ([63e691d](https://github.com/billypearson/github-action-ci-lock/commit/63e691d0f29e68ca1804d7f59a0ea6555352d6c9))

## [1.1.13](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.12...v1.1.13) (2025-05-19)


### Bug Fixes

* bump code release ([53a6d68](https://github.com/billypearson/github-action-ci-lock/commit/53a6d68de383bd4c9695382954c3439d79a78911))

## [1.1.12](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.11...v1.1.12) (2025-05-19)


### Bug Fixes

* push updates to fix some edge cases ([0544862](https://github.com/billypearson/github-action-ci-lock/commit/0544862342fb3dbab1542bde4fd547bd0bc1c9fa))

## [1.1.11](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.10...v1.1.11) (2025-05-19)


### Bug Fixes

* adding Guard every possible failure inside the loop so the script never exits unexpectedly. ([9ed1b49](https://github.com/billypearson/github-action-ci-lock/commit/9ed1b49fd9de30f90f800f6ee39f886c6b2fc743))

## [1.1.10](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.9...v1.1.10) (2025-05-19)


### Bug Fixes

* adding retry logic ([ad48442](https://github.com/billypearson/github-action-ci-lock/commit/ad48442d013151dea553fbafee1c5094b4fbbf9f))

## [1.1.9](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.8...v1.1.9) (2025-05-19)


### Bug Fixes

* delete working dir before clone ([3ba1176](https://github.com/billypearson/github-action-ci-lock/commit/3ba1176fac25529deb2ce035c130d5cc115d9d19))

## [1.1.8](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.7...v1.1.8) (2025-05-19)


### Bug Fixes

* working out errors in loop retried and existing working dir in release ([646c372](https://github.com/billypearson/github-action-ci-lock/commit/646c37231f86f5e61ac39201fd018a32a522e74d))

## [1.1.7](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.6...v1.1.7) (2025-05-19)


### Bug Fixes

* adding debugging and fix some var missing in release lock ([843d062](https://github.com/billypearson/github-action-ci-lock/commit/843d0624e37b384f30d64bf61a0b61b3d46a38d5))

## [1.1.6](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.5...v1.1.6) (2025-05-19)


### Bug Fixes

* add debuging set command at top of script ([5086515](https://github.com/billypearson/github-action-ci-lock/commit/50865153c7c125821b404f96f2c1ba3b9d8dfb03))

## [1.1.5](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.4...v1.1.5) (2025-05-19)


### Bug Fixes

* mkdir -p for lock file in case lock name is a path ([1244231](https://github.com/billypearson/github-action-ci-lock/commit/1244231d3d505a57b9fe89b1aa307f353fd4534c))

## [1.1.4](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.3...v1.1.4) (2025-05-19)


### Bug Fixes

* fix relative path to absolute path ([a710103](https://github.com/billypearson/github-action-ci-lock/commit/a71010349d9f56045778b1afc4f85e8edfaa98bf))

## [1.1.3](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.2...v1.1.3) (2025-05-19)


### Bug Fixes

* forgot required fields for env variables ([25deacb](https://github.com/billypearson/github-action-ci-lock/commit/25deacbdf446175ccd0f9227090aae8f60325628))

## [1.1.2](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.1...v1.1.2) (2025-05-19)


### Bug Fixes

* missing a dep for release ([e6baee2](https://github.com/billypearson/github-action-ci-lock/commit/e6baee2ce9a418b50cbbb4c26c99b6efe52c40a1))
* release issue with v1 tag ([7cadc41](https://github.com/billypearson/github-action-ci-lock/commit/7cadc410689896c67998997af4e0b9cfc005cfc7))

## [1.1.1](https://github.com/billypearson/github-action-ci-lock/compare/v1.1.0...v1.1.1) (2025-05-19)


### Bug Fixes

* makeing update to get v1 to follow latest 1.y.z version ([02c1953](https://github.com/billypearson/github-action-ci-lock/commit/02c19532cf14f46a8e521e6fd35ee1629f3c3787))

# [1.1.0](https://github.com/billypearson/github-action-ci-lock/compare/v1.0.0...v1.1.0) (2025-05-19)


### Features

* added retry logic to acquire-lock ([2604187](https://github.com/billypearson/github-action-ci-lock/commit/260418757abbfc679d24bfdc4428a46c9b997204))

# 1.0.0 (2025-05-19)


### Bug Fixes

* workflow rename ([ead9539](https://github.com/billypearson/github-action-ci-lock/commit/ead9539528704e3a8f07cc3c083d28dc128b0978))

# Changelog

All notable changes to this project will be documented in this file.

Generated by [semantic-release](https://github.com/semantic-release/semantic-release).
