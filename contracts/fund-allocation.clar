;; Fund Allocation Contract

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-authorized (err u101))
(define-constant err-invalid-allocation (err u102))

(define-map allocations
  { allocation-id: uint }
  {
    charity-id: uint,
    amount: uint,
    status: (string-ascii 20)
  }
)

(define-data-var last-allocation-id uint u0)

(define-public (create-allocation (charity-id uint) (amount uint))
  (let
    ((allocation-id (+ (var-get last-allocation-id) u1)))
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set allocations
      { allocation-id: allocation-id }
      {
        charity-id: charity-id,
        amount: amount,
        status: "pending"
      })
    (var-set last-allocation-id allocation-id)
    (ok allocation-id)))

(define-public (approve-allocation (allocation-id uint))
  (let
    ((allocation (unwrap! (map-get? allocations { allocation-id: allocation-id }) err-invalid-allocation)))
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (try! (as-contract (contract-call? .donation-management donate (get amount allocation) (get charity-id allocation))))
    (ok (map-set allocations
      { allocation-id: allocation-id }
      (merge allocation { status: "approved" })))))

(define-read-only (get-allocation (allocation-id uint))
  (ok (unwrap! (map-get? allocations { allocation-id: allocation-id }) err-invalid-allocation)))

