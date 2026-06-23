from sqlalchemy.ext.asyncio import create_async_engine
from app.core.config import settings
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlalchemy.orm import sessionmaker

engine = create_async_engine(
    url=settings.DB_URL,
    echo=True,
    future=True,
    pool_size=20,
    max_overflow=10
)

AsyncSessionLocal = sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autoflush=False
)