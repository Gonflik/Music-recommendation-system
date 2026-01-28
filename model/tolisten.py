from .base import Base
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, ForeignKey
from typing import List, Optional

class ToListen(Base):
    __tablename__ = "tolisten"
    pass