import os

from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, EmailStr, Field
from supabase import Client, create_client

load_dotenv()

app = FastAPI(title="API de usuarios", version="1.0.0")


class NuevoUsuario(BaseModel):
    correo: EmailStr
    clave: str = Field(min_length=6)
    nombre: str = Field(min_length=1, max_length=80)


def obtener_cliente() -> Client:
    url = os.getenv("SUPABASE_URL")
    secreto = os.getenv("SUPABASE_SECRET")
    if not url or not secreto:
        raise RuntimeError("Faltan SUPABASE_URL o SUPABASE_SECRET en api_usuarios/.env")
    return create_client(url, secreto)


@app.get("/salud")
def comprobar_salud() -> dict[str, bool]:
    return {"ok": True}


@app.post("/usuarios", status_code=201)
def crear_usuario(usuario: NuevoUsuario) -> dict[str, str | bool]:
    try:
        supabase = obtener_cliente()
        respuesta = supabase.auth.admin.create_user(
            {
                "email": usuario.correo,
                "password": usuario.clave,
                "email_confirm": True,
            }
        )
        if respuesta.user is None:
            raise RuntimeError("Supabase no devolvió el usuario creado")
        supabase.table("perfiles").insert(
            {"id": respuesta.user.id, "nombre": usuario.nombre.strip()}
        ).execute()
        return {"ok": True, "id": respuesta.user.id}
    except Exception as error:
        raise HTTPException(status_code=400, detail=str(error)) from error
