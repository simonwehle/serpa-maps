package models

import (
	"time"

	"github.com/google/uuid"
)

type Token struct {
	Jti       uuid.UUID `gorm:"type:uuid;primaryKey"`
	UserID    uuid.UUID `gorm:"type:uuid:column:user_id;not null"` 
	CreatedAt time.Time
	ExpiresAt time.Time
	Revoked   bool
}

func (Token) TableName() string {
	return "tokens"
}