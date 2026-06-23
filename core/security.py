from passlib.context import CryptContext
import uuid
from datetime import datetime, timedelta, timezone
import jwt
from typing import Dict
from .config import settings
from .exceptions import InvalidTokenException

password_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

ACCESS_TOKEN_EXPIRE_MINUTES = 20
REFRESH_TOKEN_EXPIRE_DAYS = 7


def generate_password_hash(password: str) -> str:
    hash = password_context.hash(password)

    return hash


def verify_password(password: str, hash: str) -> bool:
    return password_context.verify(password, hash)

def create_jwt_token(data: dict, expires_delta: timedelta, token_type: str) -> str:

    now = datetime.now(timezone.utc)

    to_encode = data.copy()
    to_encode.update({
        "iat": now,
        "exp": now + expires_delta,
        "type": token_type,
        "jti": str(uuid.uuid4())
    })

    token = jwt.encode(
        to_encode,
        key=settings.JWT_SECRET,
        algorithm=settings.JWT_ALGORITHM
    )

    return token

def generate_auth_token(user_uid: str) -> Dict[str,str]:
    
    access_token = create_jwt_token(
        data={"sub":str(user_uid)},
        expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES),
        token_type="access"
    )

    refresh_token = create_jwt_token(
        data={"sub":str(user_uid)},
        expires_delta=timedelta(days=REFRESH_TOKEN_EXPIRE_DAYS),
        token_type="refresh"
    )

    return{
        "access_token" :access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer"
    }

def decode_jwt_token(token: str) -> dict:
    try:
        print("\n========== JWT DEBUG START ==========")
        print("RAW TOKEN:", token)

        # decode WITHOUT validation dulu (DEBUG MODE)
        unverified = jwt.decode(
            token,
            options={"verify_signature": False}
        )
        print("UNVERIFIED PAYLOAD:", unverified)

        # normal decode (REAL VALIDATION)
        token_data = jwt.decode(
            token,
            key=settings.JWT_SECRET,
            algorithms=[settings.JWT_ALGORITHM],
            options={
                "verify_signature": True,
                "verify_exp": True,
                "verify_iat": True
            }
        )

        print("VALID TOKEN OK:", token_data)
        print("========== JWT DEBUG END ==========\n")

        return token_data

    except jwt.ExpiredSignatureError:
        print("TOKEN EXPIRED")
        raise InvalidTokenException

    except jwt.InvalidTokenError as e:
        print("INVALID TOKEN:", str(e))
        raise InvalidTokenException