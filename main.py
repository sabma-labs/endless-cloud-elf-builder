import os
import uvicorn

from fastapi import FastAPI
from pydantic import BaseModel
from llm import generate_text

app = FastAPI()

class GenerateRequest(BaseModel):
    prompt: str

@app.get("/ping")
async def root():
    return {"message": "Pong"}

@app.get("/hello/{name}")
async def say_hello(name: str):
    return {"message": f"Hello {generate_text(name)}"}

@app.post("/generate")
async def generate(request: GenerateRequest):
    result = generate_text(request.prompt)
    return {"response": result}

if __name__ == "__main__":
    address = os.getenv("HTTP_ADDRESS", "127.0.0.1:7860")
    host, port = address.split(":")

    uvicorn.run("main:app",
                host="0.0.0.0",
                port=int(port),
                reload=True)