package models

import "time"

type User struct {
	UserID    int       `gorm:"column:user_id;primaryKey;autoIncrement" json:"user_id"`
	Email     string    `gorm:"column:email;unique;not null" json:"email"`
	Username  string    `gorm:"column:username;not null" json:"username"`
	Password  string    `gorm:"column:password;not null" json:"-"`
	CreatedAt time.Time `gorm:"column:created_at;autoCreateTime" json:"created_at"`
}

func (User) TableName() string {
	return "users"
}

type UserRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

type RegisterRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Username string `json:"username" binding:"required,min=3,max=50"`
	Password string `json:"password" binding:"required,min=8"`
}