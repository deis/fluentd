### v2.0.0-rc2 -> v2.0.0

#### Documentation

- [`e945cb5`](https://github.com/deis/fluentd/commit/e945cb57f79fab482c5b835599af2bcc9da3cb51) CHANGELOG.md: add entry for v2.0.0-rc2

### v2.0.0-rc1 -> v2.0.0-rc2

### v2.0.0-beta4 -> v2.0.0-rc1

#### Maintenance

 - [`82ed849`](https://github.com/deis/fluentd/commit/82ed849bc156d0b1cafd06c65a5e0b454b646010) Dockerfile: Refactor image to use ubuntu-slim
 - [`701c9cc`](https://github.com/deis/fluentd/commit/701c9ccf5b7b6edb8e0f602500bfefd2355fe181) syslog-plugin: Remove dead code

### v2.0.0-beta3 -> v2.0.0-beta4

#### Documentation

docs(CHANGELOG.md): update for v2.0.0-beta3
 - [`b941f64`](https://github.com/deis/fluentd/commit/b941f64b1e251456ad933b8a958519873c51af69) CHANGELOG.md: update for v2.0.0-beta3

#### Maintenance

- [`f73e095`](https://github.com/deis/fluentd/commit/f73e095aec3278154cd076e14ed6909c238812ff): fix: Create new UDPSender for each message we get
    The plugin was trying to reuse connection information but this meant that if the other end died the packets would never be sent. Instead we now keep a global list of host:ports we want to send data to and iterate that list creating a new sender each time. This is wrapped in a begin/rescue/ensure block for protection

### v2.0.0-beta2 -> v2.0.0-beta3

#### Fixes

 - [`30f4eef`](https://github.com/deis/fluentd/commit/30f4eef1c5ec406e247574f682ae556e07fe3016) conf: Capture all kubernetes log streams and cleanup generated conf

#### Maintenance

 - [`dd1f83f`](https://github.com/deis/fluentd/commit/dd1f83f0e0c38203322ec80c7297f711582e348a) travis.yml: Remove travis.yml

### v2.0.0-beta1 -> v2.0.0-beta2

#### Maintenance

 - [`c2910f1`](https://github.com/deis/fluentd/commit/c2910f1c89da495aa5123e067802d5932b41f4e8) makefile: Update makefile to push canary tag when building new image
