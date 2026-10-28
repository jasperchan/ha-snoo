# ha-snoo

Home Assistant custom integration for the Happiest Baby SNOO that **replaces the core `snoo` integration** with a copy
carrying a fixed `python-snoo` library. Install it and the built-in SNOO integration is overridden; your existing config
entry keeps working, nothing to re-add.

## Why

Core Home Assistant pins `python-snoo==0.8.3`. In that library (and in 0.11.0) the MQTT subscription that delivers the
SNOO's state is opened once and never reconnected: after a single dropped connection the integration goes silent until its
next token refresh (~2 h 55 min) or a manual reload, and every command fails after a 30 s wait. See
[python-snoo #47](https://github.com/Lash-L/python-snoo/issues/47) and the fix proposed upstream in
[python-snoo PR #49](https://github.com/Lash-L/python-snoo/pull/49). Until that is merged and Home Assistant bumps the
pin, this repo ships the fix.

## What's different from core

- `python_snoo` is vendored from [jasperchan/python-snoo](https://github.com/jasperchan/python-snoo) (`main`), which
  reconnects the MQTT subscription with exponential backoff (1 s .. 5 min), picks up refreshed tokens, logs through the
  `python_snoo` logger, and keeps the connection alive if a callback raises. The commit it was taken from is recorded in
  `custom_components/snoo/python_snoo/VENDORED_FROM`.
- The event entity accepts the `restart` event the SNOO sends after a reboot (core logs a traceback for it).
- Everything else is Home Assistant 2026.10.4's `snoo` integration, unchanged.

## Install (HACS)

1. HACS → Integrations → ⋮ → *Custom repositories* → add `https://github.com/jasperchan/ha-snoo`, category *Integration*.
2. Install "Happiest Baby SNOO (reconnecting fork)" and restart Home Assistant.
3. HA logs a warning that a custom integration replaces the core `snoo` integration. That's expected.

To go back to core: remove the integration in HACS (or delete `custom_components/snoo`) and restart.

## Manual install

Copy `custom_components/snoo` into your config directory's `custom_components/` and restart.

## Updating the vendored library

```
scripts/vendor_python_snoo.sh ~/Repository/python-snoo
```
