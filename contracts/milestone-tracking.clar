;; Milestone Tracking Contract

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-authorized (err u101))
(define-constant err-invalid-milestone (err u102))

(define-map milestones
  { milestone-id: uint }
  {
    charity-id: uint,
    description: (string-utf8 500),
    target-amount: uint,
    current-amount: uint,
    status: (string-ascii 20)
  }
)

(define-data-var last-milestone-id uint u0)

(define-public (create-milestone (charity-id uint) (description (string-utf8 500)) (target-amount uint))
  (let
    ((milestone-id (+ (var-get last-milestone-id) u1)))
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set milestones
      { milestone-id: milestone-id }
      {
        charity-id: charity-id,
        description: description,
        target-amount: target-amount,
        current-amount: u0,
        status: "active"
      })
    (var-set last-milestone-id milestone-id)
    (ok milestone-id)))

(define-public (update-milestone (milestone-id uint) (amount uint))
  (let
    ((milestone (unwrap! (map-get? milestones { milestone-id: milestone-id }) err-invalid-milestone)))
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (let
      ((new-amount (+ (get current-amount milestone) amount))
       (new-status (if (>= new-amount (get target-amount milestone)) "completed" (get status milestone))))
      (ok (map-set milestones
        { milestone-id: milestone-id }
        (merge milestone {
          current-amount: new-amount,
          status: new-status
        }))))))

(define-read-only (get-milestone (milestone-id uint))
  (ok (unwrap! (map-get? milestones { milestone-id: milestone-id }) err-invalid-milestone)))

