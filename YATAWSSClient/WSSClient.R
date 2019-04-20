library(websocket)

#ws <- WebSocket$new("ws://127.0.0.1:8888/",
#                    headers = list(Cookie = "Xyz"),
#                    accessLogChannels = "all" # enable all websocketpp logging

ws <- WebSocket$new("wss://api2.poloniex.com")

ws$onOpen(function(event) {
    cat("Connection opened\n")
})
ws$onClose(function(event) {
    cat("Client disconnected with code ", event$code,
        " and reason ", event$reason, "\n", sep = "")
})
ws$onError(function(event) {
    cat("Client failed to connect: ", event$message, "\n")
})

ws$onMessage(function(event) {
    cat("RECIBIDO: ", event$data, "\n")
})

#ws$send("hello")

#ws$send(charToRaw("hello"))

#ws$close()

# { "command": "subscribe", "channel": "1002" }