# `backend` - data source/"services" conglomerate for quickshell
Instead of relying on many processes, I have decided (similar to sioodmy) to write
a Rust program that emits events to a given UNIX socket. For now the socket lives in
`~/.local/state/qs-backend`, but that is subject to change.

You shouldn't use whatever code is in here, instead, take it as inspiration, since it
will only be tied to this specific quickshell config. No guarantees on my side.
