import redis.asyncio as redis
from datetime import datetime, timedelta, timezone
from .config import settings


redis_client = redis.Redis(
    host=settings.REDIS_HOST,
    port=settings.REDIS_PORT,
    db=0,
    decode_responses=True,
    max_connections=20
)

async def add_jti_to_blacklist(jti: str, exp: int):
    now = datetime.now(timezone.utc).timestamp()
    ttl = int(exp - now)

    if ttl > 0:
        await redis_client.setex(f"blacklist:{jti}", ttl, "1")

async def is_jti_blacklisted(jti: str) -> bool:
    return await redis_client.exists(f"blacklist:{jti}") == 1