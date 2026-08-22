pragma ComponentBehavior: Bound

// A custom wrapper around IpcHandler that allows you to make asynchronous requests.
// From: https://github.com/PZeide/shiny-shell

import QtQuick
import Quickshell.Io

Item {
    id: root

    property string ipcTarget: ""
    property bool concurrent: false
    property string completedStatus: "completed"
    property string cancelledStatus: "cancelled"
    property var ipcResultMapper: result => result
    readonly property alias activeRequests: internal.activeRequests

    signal requestStarted(request: var)

    function request(handler: var, options: var): string {
        const completionHandler = typeof handler === "function" ? result => handler(result) : null;
        return internal.enqueue(completionHandler, options ?? {}, false);
    }

    function resolve(request: var, result: var): void {
        internal.complete(request, result, false);
    }

    function cancel(request: var): void {
        internal.complete(request, null, true);
    }

    QtObject {
        id: internal

        property list<var> pendingRequests: []
        property list<var> activeRequests: []
        property int nextRequestId: 0

        function enqueue(handler: var, options: var, fromIpc: bool): string {
            const key = `${Date.now().toString(36)}-${(++nextRequestId).toString(36)}`;
            pendingRequests = [...pendingRequests,
                {
                    key,
                    options,
                    handler,
                    fromIpc
                }
            ];

            dispatch();
            return key;
        }

        function dispatch(): void {
            while (pendingRequests.length > 0 && (root.concurrent || activeRequests.length === 0)) {
                const request = pendingRequests[0];
                pendingRequests = pendingRequests.slice(1);
                activeRequests = [...activeRequests, request];
                root.requestStarted(request);
            }
        }

        function complete(request: var, result: var, cancelled: bool): void {
            const key = typeof request === "string" ? request : request?.key;
            const index = activeRequests.findIndex(activeRequest => activeRequest.key === key);
            if (index < 0) {
                // console.warn("Cannot complete unknown or inactive request");
                return;
            }

            const completedRequest = activeRequests[index];
            activeRequests = activeRequests.filter((_, activeIndex) => activeIndex !== index);

            // Dispatch next request before invoking handler code.
            dispatch();

            if (completedRequest.handler) {
                try {
                    completedRequest.handler(cancelled ? null : result);
                } catch (error) {
                    console.error(`Request completion handler failed: ${error}`);
                }
            }

            if (completedRequest.fromIpc) {
                const response = {
                    key: completedRequest.key,
                    status: cancelled ? root.cancelledStatus : root.completedStatus
                };

                if (!cancelled) {
                    response.result = root.ipcResultMapper(result);
                }

                ipc.result(JSON.stringify(response));
            }
        }
    }

    IpcHandler {
        id: ipc

        signal result(result: string)

        function request(options: string): string {
            try {
                return JSON.stringify({
                    status: "ok",
                    data: internal.enqueue(null, JSON.parse(options), true)
                });
            } catch (error) {
                return JSON.stringify({
                    status: "error",
                    message: `invalid options: ${error}`
                });
            }
        }

        enabled: root.ipcTarget !== ''
        target: root.ipcTarget
    }
}
