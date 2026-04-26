import enum
import datetime
from app import db
from sqlalchemy import Enum, DateTime, func, Integer, ForeignKey, select, ARRAY
from .base import Base
from app.model.action import ReferenceClassName
from sqlalchemy.orm import Mapped, mapped_column, relationship, selectinload, joinedload
from typing import List

class Recommendation(Base):
    __tablename__ = "recommendation"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    reference_name: Mapped[ReferenceClassName] = mapped_column(
        Enum(ReferenceClassName, name="user_action_object_enum")
    )
    reference_ids: Mapped[List[int]] = mapped_column(ARRAY(Integer), default=list, nullable=False)
    
    created_at: Mapped[datetime.datetime] = mapped_column(DateTime(), default=func.now())

    user_id: Mapped[int] = mapped_column(ForeignKey("user.id"))
    user: Mapped["User"] = relationship(back_populates="recommendations")



