;; Consumption Tracking Contract
;; Tracks energy consumption for tokenized assets

(define-constant ERR_UNAUTHORIZED (err u200))
(define-constant ERR_INVALID_AMOUNT (err u201))
(define-constant ERR_ASSET_NOT_FOUND (err u202))

;; Data structures
(define-map asset-consumption uint {
    total-consumption: uint,
    last-reading: uint,
    last-updated: uint,
    manager: principal
})

(define-map consumption-history {asset-id: uint, timestamp: uint} {
    amount: uint,
    reading-type: (string-ascii 20)
})

;; Public functions
(define-public (record-consumption (asset-id uint) (amount uint) (reading-type (string-ascii 20)))
    (let ((current-data (default-to {total-consumption: u0, last-reading: u0, last-updated: u0, manager: tx-sender}
                                   (map-get? asset-consumption asset-id))))
        (begin
            (asserts! (> amount u0) ERR_INVALID_AMOUNT)
            (map-set asset-consumption asset-id {
                total-consumption: (+ (get total-consumption current-data) amount),
                last-reading: amount,
                last-updated: block-height,
                manager: tx-sender
            })
            (map-set consumption-history {asset-id: asset-id, timestamp: block-height} {
                amount: amount,
                reading-type: reading-type
            })
            (ok true)
        )
    )
)

(define-public (update-asset-manager (asset-id uint) (new-manager principal))
    (let ((current-data (map-get? asset-consumption asset-id)))
        (begin
            (asserts! (is-some current-data) ERR_ASSET_NOT_FOUND)
            (asserts! (is-eq tx-sender (get manager (unwrap-panic current-data))) ERR_UNAUTHORIZED)
            (map-set asset-consumption asset-id
                (merge (unwrap-panic current-data) {manager: new-manager}))
            (ok true)
        )
    )
)

;; Read-only functions
(define-read-only (get-consumption-data (asset-id uint))
    (map-get? asset-consumption asset-id)
)

(define-read-only (get-consumption-history (asset-id uint) (timestamp uint))
    (map-get? consumption-history {asset-id: asset-id, timestamp: timestamp})
)

(define-read-only (get-total-consumption (asset-id uint))
    (match (map-get? asset-consumption asset-id)
        data (some (get total-consumption data))
        none
    )
)
