
import asyncio
import json
from datetime import datetime
from websockets.asyncio.server import serve

CLIENTES = set()

async def manejar_cliente(websocket):
    CLIENTES.add(websocket)
    print("Cliente conectado")

    try:
        async for mensaje in websocket:
            respuesta = {
                "sistema": "SCRUM_PLANNING",
                "mensaje": mensaje,
                "fecha": datetime.now().isoformat(),
                "estado": "recibido"
            }

            await websocket.send(json.dumps(respuesta))
    finally:
        CLIENTES.discard(websocket)
        print("Cliente desconectado")

async def main():
    async with serve(manejar_cliente, "localhost", 8765):
        print("WebSocket activo en ws://localhost:8765")
        await asyncio.Future()

if __name__ == "__main__":
    asyncio.run(main())
