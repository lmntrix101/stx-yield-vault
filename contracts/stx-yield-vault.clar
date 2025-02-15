;; Project Name: Stacks Yield Vault (SYV)
;;
;; Description:
;; A simple liquidity vault that lets users deposit STX to earn yield from a reward pool.
;; When users withdraw, they receive their deposited amount plus a proportional share of the reward pool.
;; The admin can fund the reward pool using the `fund-rewards` function.

(define-constant ADMIN tx-sender)

;; Global state
(define-data-var total-deposits uint u0)
(define-data-var reward-pool uint u0)
(define-map user-balances { user: principal } uint)

;; -------------------------------
;; Deposit STX into the Vault
;; -------------------------------
(define-public (deposit (amount uint))
  (begin
    ;; Require a positive deposit amount.
    (asserts! (> amount u0) (err u100))
    ;; Transfer STX from the sender to the contract.
    (match (stx-transfer? amount tx-sender (as-contract tx-sender))
      success
        (begin
          (let ((current (default-to u0 (map-get? user-balances { user: tx-sender }))))
            (map-set user-balances { user: tx-sender } (+ current amount)))
          (var-set total-deposits (+ (var-get total-deposits) amount))
          (ok true))
      failure (err u101)
    )
  )
)

;; -------------------------------
;; Withdraw STX plus Reward Share
;; -------------------------------
(define-public (withdraw (amount uint))
  (let (
        (balance (default-to u0 (map-get? user-balances { user: tx-sender })))
        (total (var-get total-deposits))
        (pool (var-get reward-pool))
       )
    (begin
      ;; Check for a positive withdrawal amount and sufficient balance.
      (asserts! (> amount u0) (err u107))
      (asserts! (>= balance amount) (err u102))
      ;; Calculate the reward share: proportional to the amount withdrawn.
      (let ((reward (/ (* amount pool) total)))
         (match (stx-transfer? (+ amount reward) (as-contract tx-sender) tx-sender)
            success
              (begin
                (map-set user-balances { user: tx-sender } (- balance amount))
                (var-set total-deposits (- total amount))
                (var-set reward-pool (- pool reward))
                (ok true))
            failure (err u101)
         )
      )
    )
  )
)

;; -------------------------------
;; Admin: Fund the Reward Pool
;; -------------------------------
(define-public (fund-rewards (amount uint))
  (begin
    (asserts! (is-eq tx-sender ADMIN) (err u104))
    (asserts! (> amount u0) (err u108))
    (match (stx-transfer? amount tx-sender (as-contract tx-sender))
      success
         (begin
           (var-set reward-pool (+ (var-get reward-pool) amount))
           (ok true))
      failure (err u101)
    )
  )
)

;; -------------------------------
;; Get User Balance
;; -------------------------------
(define-read-only (get-user-balance (user principal))
  (ok (default-to u0 (map-get? user-balances { user: user })))
)

;; -------------------------------
;; Get Total Deposits
;; -------------------------------
(define-read-only (get-total-deposits)
  (ok (var-get total-deposits))
)

;; -------------------------------
;; Get Reward Pool
;; -------------------------------
(define-read-only (get-reward-pool)
  (ok (var-get reward-pool))
)
