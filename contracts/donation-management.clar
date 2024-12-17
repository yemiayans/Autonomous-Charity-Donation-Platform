;; Donation Management Contract

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-authorized (err u101))
(define-constant err-invalid-charity (err u102))

(define-fungible-token donation-token)

(define-map charities
  { charity-id: uint }
  {
    name: (string-utf8 100),
    description: (string-utf8 500),
    wallet: principal,
    total-received: uint,
    total-allocated: uint
  }
)

(define-data-var last-charity-id uint u0)

(define-public (register-charity (name (string-utf8 100)) (description (string-utf8 500)) (wallet principal))
  (let
    ((charity-id (+ (var-get last-charity-id) u1)))
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set charities
      { charity-id: charity-id }
      {
        name: name,
        description: description,
        wallet: wallet,
        total-received: u0,
        total-allocated: u0
      })
    (var-set last-charity-id charity-id)
    (ok charity-id)))

(define-public (donate (amount uint) (charity-id uint))
  (let
    ((charity (unwrap! (map-get? charities { charity-id: charity-id }) err-invalid-charity)))
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    (try! (ft-mint? donation-token amount tx-sender))
    (ok (map-set charities
      { charity-id: charity-id }
      (merge charity {
        total-received: (+ (get total-received charity) amount)
      })))))

(define-read-only (get-charity (charity-id uint))
  (ok (unwrap! (map-get? charities { charity-id: charity-id }) err-invalid-charity)))

(define-read-only (get-donation-token-balance (account principal))
  (ok (ft-get-balance donation-token account)))

