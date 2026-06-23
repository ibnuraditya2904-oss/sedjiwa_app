from typing import List

from fastapi import Depends, Request
from fastapi.security import HTTPBearer
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.db import AsyncSessionLocal
from app.core.redis import  is_jti_blacklisted
import jwt
from app.core.security import decode_jwt_token
from app.models.enum import UserRole
from app.models.user import User
from app.repositories import user_repo
from app.core.exceptions import AccessTokenException, RefreshTokenException, UserInactiveException,UserNotFoundException,RevokedTokenException, AccessException


async def get_session() ->AsyncSession :
    async with AsyncSessionLocal() as session:
        yield session

async def get_user_repository(session: AsyncSession = Depends(get_session)):
    return user_repo.UserRepository(session)
        
class TokenBearer(HTTPBearer):
    def __init__(self, auto_error:bool = True):
        super().__init__(auto_error=auto_error)

    async def __call__(self, request: Request) -> dict:
        print("HEADERS:", dict(request.headers))

        creds = await super().__call__(request)

        print("CREDENTIALS:", creds)

        token = creds.credentials
        print("TOKEN:", token)

        token_data = decode_jwt_token(token)

        jti = token_data.get("jti")
        
        if await is_jti_blacklisted(jti):
            raise RevokedTokenException

        self.verify_token_data(token_data)

        return token_data

    def verify_token_data(self, token_data):
        raise NotImplementedError("Please Overide this method in child class")

class AccessTokenBearer(TokenBearer):
    def verify_token_data(self, token_data: dict)-> None:
        if token_data and token_data.get("type") != "access":
            raise AccessTokenException

class RefreshTokenBearer(TokenBearer):
    def verify_token_data(self, token_data: dict)-> None:
        if token_data and token_data.get("type") != "refresh":
            raise RefreshTokenException
        

async def get_current_user(
        token_data: dict = Depends(AccessTokenBearer()),
        user_repo: user_repo.UserRepository = Depends(get_user_repository)
        ):
    user_uid = token_data.get("sub")
    
    user = await user_repo.get_user_by_id(user_uid)
    
    if not user:
        raise UserNotFoundException
    
    if not user.is_active:
        raise UserInactiveException
    
    return user

def require_roles(allowed_roles: List[UserRole]):

    def role_checker(current_user: User = Depends(get_current_user)):
        if current_user.role == UserRole.superadmin:
            return current_user

        if current_user.role not in allowed_roles:
            raise AccessException
            
        return current_user
        
    return role_checker