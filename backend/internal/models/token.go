package models

import (
	"time"

	"github.com/google/uuid"
)

type RefreshToken struct {
	Jti       uuid.UUID `gorm:"type:uuid;primaryKey"`
	UserID    uuid.UUID `gorm:"type:uuid;not null;index"`
	User      User      `gorm:"constraint:OnDelete:CASCADE;"`
	CreatedAt time.Time `gorm:"not null"`
	ExpiresAt time.Time `gorm:"not null;index"`
	Revoked   bool      `gorm:"default:false;not null"`
}

func (RefreshToken) TableName() string {
	return "refresh_tokens"
}