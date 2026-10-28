
import asyncio
import websockets

async def main():
    uri = "ws://localhost:8765"

    try:
        async with websockets.connect(uri) as websocket:
            print("Conectado al servidor WebSocket")

            while True:
                mensaje = input("Escribe un mensaje (salir para terminar): ")

                if mensaje.lower() == "salir":
                    break

                await websocket.send(mensaje)
                respuesta = await websocket.recv()

                print("Respuesta del servidor:", respuesta)

    except OSError as error:
        print("No se pudo conectar al servidor:", error)

if __name__ == "__main__":
    asyncio.run(main())
