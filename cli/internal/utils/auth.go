package utils

import "net/http"

func SetBearerAuth(req *http.Request, accessToken string) {
	req.Header.Set("Authorization", "Bearer "+accessToken)
}