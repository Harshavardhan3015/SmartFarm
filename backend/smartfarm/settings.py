"""
Django settings for smartfarm project.
"""

from pathlib import Path
from datetime import timedelta
import os

# -------------------------------------------------
# BASE DIRECTORY
# -------------------------------------------------
BASE_DIR = Path(__file__).resolve().parent.parent


# -------------------------------------------------
# SECURITY SETTINGS
# -------------------------------------------------
SECRET_KEY = 'django-insecure--v0w=c9al@9yhl0ejm^xlf=6q-kv%3(55!pve2h!%e-qa*12%2'

DEBUG = True

ALLOWED_HOSTS = []


# -------------------------------------------------
# APPLICATIONS
# -------------------------------------------------
INSTALLED_APPS = [
    # Default Django apps
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    # Third-party apps
    'rest_framework',
    'corsheaders',

    # Local apps
    'users',
    'uploads',
    'marketplace',
    'ml_inference',
]


# -------------------------------------------------
# MIDDLEWARE
# -------------------------------------------------
MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',  # Must be at top
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]


ROOT_URLCONF = 'smartfarm.urls'


# -------------------------------------------------
# TEMPLATES
# -------------------------------------------------
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]


WSGI_APPLICATION = 'smartfarm.wsgi.application'


# -------------------------------------------------
# DATABASE
# -------------------------------------------------
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}


# -------------------------------------------------
# CUSTOM USER MODEL
# -------------------------------------------------
AUTH_USER_MODEL = "users.User"


# -------------------------------------------------
# PASSWORD VALIDATION
# -------------------------------------------------
AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# -------------------------------------------------
# INTERNATIONALIZATION
# -------------------------------------------------
LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True


# -------------------------------------------------
# STATIC & MEDIA FILES
# -------------------------------------------------
STATIC_URL = 'static/'

MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'


DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'


# -------------------------------------------------
# DJANGO REST FRAMEWORK
# -------------------------------------------------
REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": (
        "rest_framework_simplejwt.authentication.JWTAuthentication",
    ),
}


# -------------------------------------------------
# JWT SETTINGS
# -------------------------------------------------
SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": timedelta(minutes=30),
    "REFRESH_TOKEN_LIFETIME": timedelta(days=7),
    "AUTH_HEADER_TYPES": ("Bearer",),
}


# -------------------------------------------------
# CORS SETTINGS (For Flutter / Frontend)
# -------------------------------------------------
CORS_ALLOW_ALL_ORIGINS = True
