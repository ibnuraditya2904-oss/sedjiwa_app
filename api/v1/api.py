from fastapi import APIRouter
from app.api.v1 import assmt_router,auth_router,user_router,recomm_router
from app.api.v1.dashboard import user_assmt_router, user_home_router, user_recomm_router
from app.api.v1.admin import admin_home_router, admin_assmt_router,admin_recomm_router, admin_user_router, admin_activity_router, admin_quest_router
from app.api.v1.psychologist import psycho_home_router, psycho_assmt_router, psycho_recomm_router,psycho_activity_router,psycho_quest_router

api_router = APIRouter()

api_router.include_router(auth_router.auth_routers, prefix="/auth", tags=["Auth"])
api_router.include_router(user_router.user_router, prefix="/me", tags=["Users"])
api_router.include_router(assmt_router.assmt_router, prefix="/assessments", tags=["Assessments"])
api_router.include_router(recomm_router.recomm_router, prefix="/recommendation", tags=["Recommendation"])

api_router.include_router(user_home_router.user_dash_router, prefix="/dashboard", tags=["Dasboard Home"])
api_router.include_router(user_recomm_router.recomm_dash_router, prefix="/dashboard/recomm", tags=["Dasboard Recommendation"])
api_router.include_router(user_assmt_router.user_assmt_router, prefix="/dashboard/assmt", tags=["Dasboard Assessment"])

api_router.include_router(psycho_home_router.psy_home_router, prefix="/psych/home", tags=["Psychologist Home"])
api_router.include_router(psycho_assmt_router.psych_assmt_router, prefix="/psych/assmt", tags=["Psychologist Assessment"])
api_router.include_router(psycho_recomm_router.psych_recommendation_router, prefix="/psych/recomm", tags=["Psychologist Reccommendation"])
api_router.include_router(psycho_quest_router.psych_quest_router, prefix="/psych/question", tags=["Psychologist Question"])
api_router.include_router(psycho_activity_router.psych_activity_router, prefix="/psych/activity", tags=["Psychologist Activity"])



api_router.include_router(admin_home_router.admin_home_router, prefix="/admin/home", tags=["Admin Home"])
api_router.include_router(admin_assmt_router.admin_assmt_router, prefix="/admin/assmt", tags=["Admin Assessment"])
api_router.include_router(admin_recomm_router.admin_recommendation_router, prefix="/admin/recomm", tags=["Admin Reccommendation"])
api_router.include_router(admin_quest_router.admin_quest_router, prefix="/admin/question", tags=["Admin Question"])
api_router.include_router(admin_activity_router.admin_activity_router, prefix="/admin/activity", tags=["Admin Activity"])
api_router.include_router(admin_user_router.admin_user_router, prefix="/admin/user", tags=["Admin User"])
