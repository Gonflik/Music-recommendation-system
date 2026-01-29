from .base import Base
from .associations.tolisten_album_association import tolisten_album_association
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, ForeignKey
from typing import List, Optional

class ToListen(Base):
    __tablename__ = "tolisten"
    
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    note: Mapped[str] = mapped_column(String(300))
    user_id: Mapped[int] = mapped_column(ForeignKey("user.id"))

    user: Mapped["User"] = relationship(back_populates="tolisten")
    albums: Mapped[List["Album"]] = relationship(
        secondary=tolisten_album_association,
        back_populates="tolisten",
    )