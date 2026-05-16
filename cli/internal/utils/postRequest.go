package utils

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

func DoPostRequest[T any](url string, payload any, accessToken string) (*T, error) {
    jsonData, err := json.Marshal(payload)
    if err != nil {
        return nil, fmt.Errorf("error marshalling payload: %w", err)
    }
    req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonData))
    if err != nil {
        return nil, fmt.Errorf("Error creating request: %w", err)
    }
    req.Header.Set("Content-Type", "application/json")
    SetBearerAuth(req, accessToken)

    client := &http.Client{}
    resp, err := client.Do(req)
    if err != nil {
        return nil, fmt.Errorf("Error sending request: %w", err)
    }
    defer resp.Body.Close()
    body, err := io.ReadAll(resp.Body)
    if err != nil {
        return nil, fmt.Errorf("Error reading response body: %w", err)
    }

    if resp.StatusCode != http.StatusCreated && resp.StatusCode != http.StatusOK {
        return nil, fmt.Errorf("API returned non-success status: %d, body: %s", resp.StatusCode, string(body))
    }

    var result T
    if err := json.Unmarshal(body, &result); err != nil {
        return nil, fmt.Errorf("Error unmarshalling response: %w", err)
    }
    return &result, nil
}
