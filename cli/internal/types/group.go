package types

import (
	"time"
)

type Group struct {
    GroupID     string    `json:"group_id"`
    Name        string    `json:"name"`
    Description string    `json:"description"`
    CreatedAt   time.Time `json:"created_at"`
    Role        string    `json:"role"`
}