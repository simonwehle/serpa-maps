package models

// TODO: add UUID later

type Category struct {
	CategoryID  int    `gorm:"column:category_id;primaryKey;autoIncrement" json:"category_id"`
	Name        string `gorm:"column:name;not null" json:"name"`
	Icon        string `gorm:"column:icon" json:"icon"`
	Color       string `gorm:"column:color" json:"color"`
}

func (Category) TableName() string {
	return "categories"
}