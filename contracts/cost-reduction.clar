;; Cost Reduction Contract
;; Manages energy cost reduction strategies

(define-constant ERR_UNAUTHORIZED (err u500))
(define-constant ERR_INVALID_AMOUNT (err u501))
(define-constant ERR_STRATEGY_NOT_FOUND (err u502))

;; Data maps
(define-map cost-reduction-strategies uint {
    strategy-name: (string-ascii 50),
    baseline-cost: uint,
    target-cost: uint,
    actual-cost: uint,
    savings-achieved: uint,
    implementation-date: uint,
    manager: principal
})

(define-map monthly-savings {asset-id: uint, month: uint} {
    projected-savings: uint,
    actual-savings: uint,
    cost-before: uint,
    cost-after: uint
})

;; Public functions
(define-public (create-cost-reduction-strategy
    (strategy-id uint)
    (strategy-name (string-ascii 50))
    (baseline-cost uint)
    (target-cost uint))
    (begin
        (asserts! (and (> baseline-cost u0) (> target-cost u0) (< target-cost baseline-cost)) ERR_INVALID_AMOUNT)
        (map-set cost-reduction-strategies strategy-id {
            strategy-name: strategy-name,
            baseline-cost: baseline-cost,
            target-cost: target-cost,
            actual-cost: baseline-cost,
            savings-achieved: u0,
            implementation-date: block-height,
            manager: tx-sender
        })
        (ok true)
    )
)

(define-public (update-actual-cost (strategy-id uint) (new-cost uint))
    (let ((strategy-data (map-get? cost-reduction-strategies strategy-id)))
        (begin
            (asserts! (is-some strategy-data) ERR_STRATEGY_NOT_FOUND)
            (asserts! (is-eq tx-sender (get manager (unwrap-panic strategy-data))) ERR_UNAUTHORIZED)
            (asserts! (> new-cost u0) ERR_INVALID_AMOUNT)
            (let ((baseline (get baseline-cost (unwrap-panic strategy-data)))
                  (savings (if (> baseline new-cost) (- baseline new-cost) u0)))
                (map-set cost-reduction-strategies strategy-id
                    (merge (unwrap-panic strategy-data) {
                        actual-cost: new-cost,
                        savings-achieved: savings
                    }))
                (ok savings)
            )
        )
    )
)

(define-public (record-monthly-savings (asset-id uint) (month uint) (projected uint) (actual uint) (cost-before uint) (cost-after uint))
    (begin
        (asserts! (and (> cost-before u0) (>= cost-before cost-after)) ERR_INVALID_AMOUNT)
        (map-set monthly-savings {asset-id: asset-id, month: month} {
            projected-savings: projected,
            actual-savings: actual,
            cost-before: cost-before,
            cost-after: cost-after
        })
        (ok true)
    )
)

;; Read-only functions
(define-read-only (get-cost-reduction-strategy (strategy-id uint))
    (map-get? cost-reduction-strategies strategy-id)
)

(define-read-only (get-monthly-savings (asset-id uint) (month uint))
    (map-get? monthly-savings {asset-id: asset-id, month: month})
)

(define-read-only (calculate-savings-percentage (strategy-id uint))
    (match (map-get? cost-reduction-strategies strategy-id)
        strategy (if (> (get baseline-cost strategy) u0)
                    (/ (* (get savings-achieved strategy) u100) (get baseline-cost strategy))
                    u0)
        u0
    )
)

(define-read-only (is-target-achieved (strategy-id uint))
    (match (map-get? cost-reduction-strategies strategy-id)
        strategy (<= (get actual-cost strategy) (get target-cost strategy))
        false
    )
)
