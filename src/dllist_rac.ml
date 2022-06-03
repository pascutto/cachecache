include Dllist
module Ortac_runtime = Ortac_runtime
let __invariant___001_ __error___002_ __position___003_ t_1 =
  if
    not
      (try
         Ortac_runtime.Z.gt (Ortac_runtime.Z.of_int t_1.cap)
           (Ortac_runtime.Z.of_int 0)
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "((integer_of_int \n(t_1:'a t).cap):integer > 0:integer):prop";
                 term_kind = __position___003_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___002_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "((integer_of_int \n(t_1:'a t).cap):integer > 0:integer):prop";
         position = __position___003_
       })
      |> (Ortac_runtime.Errors.register __error___002_)
let __invariant___004_ __error___005_ __position___006_ t_1 =
  if
    not
      (try
         let __t1__007_ =
           Ortac_runtime.Z.leq
             (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1))
             (Ortac_runtime.Z.of_int t_1.free) in
         let __t2__008_ =
           Ortac_runtime.Z.lt (Ortac_runtime.Z.of_int t_1.free)
             (Ortac_runtime.Z.of_int t_1.cap) in
         __t1__007_ && __t2__008_
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "((prefix -  1:integer):integer <= (integer_of_int \n(t_1:'a t).free):integer):prop /\\ ((integer_of_int \n(t_1:'a t).free):integer < (integer_of_int \n(t_1:'a t).cap):integer):prop";
                 term_kind = __position___006_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___005_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "((prefix -  1:integer):integer <= (integer_of_int \n(t_1:'a t).free):integer):prop /\\ ((integer_of_int \n(t_1:'a t).free):integer < (integer_of_int \n(t_1:'a t).cap):integer):prop";
         position = __position___006_
       })
      |> (Ortac_runtime.Errors.register __error___005_)
let __invariant___009_ __error___010_ __position___011_ t_1 =
  if
    not
      (try
         (not
            (not
               ((Ortac_runtime.Z.of_int t_1.free) =
                  (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1)))))
           ||
           ((Ortac_runtime.Z.of_int
               (Ortac_runtime.Array.get t_1.prev
                  (Ortac_runtime.Z.of_int t_1.free)))
              = (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1)))
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "not ((integer_of_int  (t_1:'a t).free):integer = (prefix - \n1:integer):integer):prop -> ((integer_of_int \n(get  (t_1:'a t).prev (integer_of_int  (t_1:'a t).free):integer):int):\ninteger = (prefix - \n1:integer):integer):prop";
                 term_kind = __position___011_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___010_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "not ((integer_of_int  (t_1:'a t).free):integer = (prefix - \n1:integer):integer):prop -> ((integer_of_int \n(get  (t_1:'a t).prev (integer_of_int  (t_1:'a t).free):integer):int):\ninteger = (prefix - \n1:integer):integer):prop";
         position = __position___011_
       })
      |> (Ortac_runtime.Errors.register __error___010_)
let __invariant___012_ __error___013_ __position___014_ t_1 =
  if
    not
      (try
         Ortac_runtime.Z.forall (Ortac_runtime.Z.of_int 0)
           (Ortac_runtime.Z.pred (Ortac_runtime.Z.of_int t_1.cap))
           (fun i ->
              let __t1__015_ =
                Ortac_runtime.Z.leq
                  (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1))
                  (Ortac_runtime.Z.of_int
                     (Ortac_runtime.Array.get t_1.next i)) in
              let __t2__016_ =
                Ortac_runtime.Z.lt
                  (Ortac_runtime.Z.of_int
                     (Ortac_runtime.Array.get t_1.next i))
                  (Ortac_runtime.Z.of_int t_1.cap) in
              __t1__015_ && __t2__016_)
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "forall i:integer. (0:integer <= i:integer):prop /\\ (i:integer < (integer_of_int \n(t_1:'a t).cap):integer):prop -> ((prefix - \n1:integer):integer <= (integer_of_int \n(get  (t_1:'a t).next i:integer):int):integer):prop /\\ ((integer_of_int \n(get  (t_1:'a t).next i:integer):int):integer < (integer_of_int \n(t_1:'a t).cap):integer):prop";
                 term_kind = __position___014_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___013_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "forall i:integer. (0:integer <= i:integer):prop /\\ (i:integer < (integer_of_int \n(t_1:'a t).cap):integer):prop -> ((prefix - \n1:integer):integer <= (integer_of_int \n(get  (t_1:'a t).next i:integer):int):integer):prop /\\ ((integer_of_int \n(get  (t_1:'a t).next i:integer):int):integer < (integer_of_int \n(t_1:'a t).cap):integer):prop";
         position = __position___014_
       })
      |> (Ortac_runtime.Errors.register __error___013_)
let __invariant___017_ __error___018_ __position___019_ t_1 =
  if
    not
      (try
         Ortac_runtime.Z.forall (Ortac_runtime.Z.of_int 0)
           (Ortac_runtime.Z.pred (Ortac_runtime.Z.of_int t_1.cap))
           (fun i_1 ->
              let __t1__020_ =
                Ortac_runtime.Z.leq
                  (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1))
                  (Ortac_runtime.Z.of_int
                     (Ortac_runtime.Array.get t_1.prev i_1)) in
              let __t2__021_ =
                Ortac_runtime.Z.lt
                  (Ortac_runtime.Z.of_int
                     (Ortac_runtime.Array.get t_1.prev i_1))
                  (Ortac_runtime.Z.of_int t_1.cap) in
              __t1__020_ && __t2__021_)
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "forall i_1:integer. (0:integer <= i_1:integer):prop /\\ (i_1:integer < (integer_of_int \n(t_1:'a t).cap):integer):prop -> ((prefix - \n1:integer):integer <= (integer_of_int \n(get  (t_1:'a t).prev i_1:integer):int):integer):prop /\\ ((integer_of_int \n(get  (t_1:'a t).prev i_1:integer):int):integer < (integer_of_int \n(t_1:'a t).cap):integer):prop";
                 term_kind = __position___019_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___018_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "forall i_1:integer. (0:integer <= i_1:integer):prop /\\ (i_1:integer < (integer_of_int \n(t_1:'a t).cap):integer):prop -> ((prefix - \n1:integer):integer <= (integer_of_int \n(get  (t_1:'a t).prev i_1:integer):int):integer):prop /\\ ((integer_of_int \n(get  (t_1:'a t).prev i_1:integer):int):integer < (integer_of_int \n(t_1:'a t).cap):integer):prop";
         position = __position___019_
       })
      |> (Ortac_runtime.Errors.register __error___018_)
let __invariant___022_ __error___023_ __position___024_ t_1 =
  if
    not
      (try
         Ortac_runtime.Z.forall (Ortac_runtime.Z.of_int 0)
           (Ortac_runtime.Z.pred (Ortac_runtime.Z.of_int t_1.cap))
           (fun i_2 ->
              (not
                 (not
                    ((Ortac_runtime.Z.of_int
                        (Ortac_runtime.Array.get t_1.next i_2))
                       = (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1)))))
                ||
                ((Ortac_runtime.Z.of_int
                    (Ortac_runtime.Array.get t_1.prev
                       (Ortac_runtime.Z.of_int
                          (Ortac_runtime.Array.get t_1.next i_2))))
                   = i_2))
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "forall i_2:integer. (0:integer <= i_2:integer):prop /\\ (i_2:integer < (integer_of_int \n(t_1:'a t).cap):integer):prop -> not ((integer_of_int \n(get  (t_1:'a t).next i_2:integer):int):integer = (prefix - \n1:integer):integer):prop -> ((integer_of_int \n(get \n(t_1:'a t).prev (integer_of_int \n(get  (t_1:'a t).next i_2:integer):int):integer):int):integer = i_2:integer):prop";
                 term_kind = __position___024_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___023_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "forall i_2:integer. (0:integer <= i_2:integer):prop /\\ (i_2:integer < (integer_of_int \n(t_1:'a t).cap):integer):prop -> not ((integer_of_int \n(get  (t_1:'a t).next i_2:integer):int):integer = (prefix - \n1:integer):integer):prop -> ((integer_of_int \n(get \n(t_1:'a t).prev (integer_of_int \n(get  (t_1:'a t).next i_2:integer):int):integer):int):integer = i_2:integer):prop";
         position = __position___024_
       })
      |> (Ortac_runtime.Errors.register __error___023_)
let __invariant___025_ __error___026_ __position___027_ t_1 =
  if
    not
      (try
         Ortac_runtime.Z.forall (Ortac_runtime.Z.of_int 0)
           (Ortac_runtime.Z.pred (Ortac_runtime.Z.of_int t_1.cap))
           (fun i_3 ->
              (not
                 (not
                    ((Ortac_runtime.Z.of_int
                        (Ortac_runtime.Array.get t_1.prev i_3))
                       = (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1)))))
                ||
                ((Ortac_runtime.Z.of_int
                    (Ortac_runtime.Array.get t_1.next
                       (Ortac_runtime.Z.of_int
                          (Ortac_runtime.Array.get t_1.prev i_3))))
                   = i_3))
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "forall i_3:integer. (0:integer <= i_3:integer):prop /\\ (i_3:integer < (integer_of_int \n(t_1:'a t).cap):integer):prop -> not ((integer_of_int \n(get  (t_1:'a t).prev i_3:integer):int):integer = (prefix - \n1:integer):integer):prop -> ((integer_of_int \n(get \n(t_1:'a t).next (integer_of_int \n(get  (t_1:'a t).prev i_3:integer):int):integer):int):integer = i_3:integer):prop";
                 term_kind = __position___027_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___026_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "forall i_3:integer. (0:integer <= i_3:integer):prop /\\ (i_3:integer < (integer_of_int \n(t_1:'a t).cap):integer):prop -> not ((integer_of_int \n(get  (t_1:'a t).prev i_3:integer):int):integer = (prefix - \n1:integer):integer):prop -> ((integer_of_int \n(get \n(t_1:'a t).next (integer_of_int \n(get  (t_1:'a t).prev i_3:integer):int):integer):int):integer = i_3:integer):prop";
         position = __position___027_
       })
      |> (Ortac_runtime.Errors.register __error___026_)
let rec __logical_aux_mem__028_ t_2 start c =
  let __t1__029_ = start = c in
  let __t2__030_ =
    (not
       ((Ortac_runtime.Z.of_int start) =
          (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1))))
      &&
      (__logical_aux_mem__028_ t_2
         (Ortac_runtime.Array.get t_2.next (Ortac_runtime.Z.of_int start)) c) in
  __t1__029_ || __t2__030_
let __invariant___031_ __error___032_ __position___033_ l_1 =
  if
    not
      (try
         ((Ortac_runtime.Z.of_int l_1.first) =
            (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1)))
           =
           ((Ortac_runtime.Z.of_int l_1.last) =
              (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1)))
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "((integer_of_int  (l_1:'a l).first):integer = (prefix - \n1:integer):integer):prop <-> ((integer_of_int \n(l_1:'a l).last):integer = (prefix - \n1:integer):integer):prop";
                 term_kind = __position___033_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___032_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "((integer_of_int  (l_1:'a l).first):integer = (prefix - \n1:integer):integer):prop <-> ((integer_of_int \n(l_1:'a l).last):integer = (prefix - \n1:integer):integer):prop";
         position = __position___033_
       })
      |> (Ortac_runtime.Errors.register __error___032_)
let __invariant___034_ __error___035_ __position___036_ l_1 =
  if
    not
      (try
         ((Ortac_runtime.Z.of_int l_1.first) =
            (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1)))
           = ((Ortac_runtime.Z.of_int l_1.size) = (Ortac_runtime.Z.of_int 0))
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "((integer_of_int  (l_1:'a l).first):integer = (prefix - \n1:integer):integer):prop <-> ((integer_of_int \n(l_1:'a l).size):integer = 0:integer):prop";
                 term_kind = __position___036_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___035_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "((integer_of_int  (l_1:'a l).first):integer = (prefix - \n1:integer):integer):prop <-> ((integer_of_int \n(l_1:'a l).size):integer = 0:integer):prop";
         position = __position___036_
       })
      |> (Ortac_runtime.Errors.register __error___035_)
let __invariant___037_ __error___038_ __position___039_ l_1 =
  if
    not
      (try
         (l_1.first = l_1.last) =
           (let __t1__040_ =
              (Ortac_runtime.Z.of_int l_1.size) = (Ortac_runtime.Z.of_int 1) in
            let __t2__041_ =
              (Ortac_runtime.Z.of_int l_1.size) = (Ortac_runtime.Z.of_int 0) in
            __t1__040_ || __t2__041_)
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "((l_1:'a l).first = (l_1:'a l).last):prop <-> ((integer_of_int \n(l_1:'a l).size):integer = 1:integer):prop \\/ ((integer_of_int \n(l_1:'a l).size):integer = 0:integer):prop";
                 term_kind = __position___039_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___038_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "((l_1:'a l).first = (l_1:'a l).last):prop <-> ((integer_of_int \n(l_1:'a l).size):integer = 1:integer):prop \\/ ((integer_of_int \n(l_1:'a l).size):integer = 0:integer):prop";
         position = __position___039_
       })
      |> (Ortac_runtime.Errors.register __error___038_)
let __invariant___042_ __error___043_ __position___044_ l_1 =
  if
    not
      (try
         (not
            (not
               ((Ortac_runtime.Z.of_int l_1.size) =
                  (Ortac_runtime.Z.of_int 0))))
           ||
           (let __t1__045_ =
              (Ortac_runtime.Z.of_int
                 (Ortac_runtime.Array.get (l_1.t).prev
                    (Ortac_runtime.Z.of_int l_1.first)))
                = (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1)) in
            let __t2__046_ =
              (Ortac_runtime.Z.of_int
                 (Ortac_runtime.Array.get (l_1.t).next
                    (Ortac_runtime.Z.of_int l_1.last)))
                = (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1)) in
            __t1__045_ && __t2__046_)
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "not ((integer_of_int \n(l_1:'a l).size):integer = 0:integer):prop -> ((integer_of_int \n(get  ((l_1:'a l).t_3).prev (integer_of_int  (l_1:'a l).first):integer):int):\ninteger = (prefix -  1:integer):integer):prop /\\ ((integer_of_int \n(get  ((l_1:'a l).t_3).next (integer_of_int  (l_1:'a l).last):integer):int):\ninteger = (prefix - \n1:integer):integer):prop";
                 term_kind = __position___044_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___043_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "not ((integer_of_int \n(l_1:'a l).size):integer = 0:integer):prop -> ((integer_of_int \n(get  ((l_1:'a l).t_3).prev (integer_of_int  (l_1:'a l).first):integer):int):\ninteger = (prefix -  1:integer):integer):prop /\\ ((integer_of_int \n(get  ((l_1:'a l).t_3).next (integer_of_int  (l_1:'a l).last):integer):int):\ninteger = (prefix - \n1:integer):integer):prop";
         position = __position___044_
       })
      |> (Ortac_runtime.Errors.register __error___043_)
let __invariant___047_ __error___048_ __position___049_ l_1 =
  if
    not
      (try
         Ortac_runtime.Z.leq (Ortac_runtime.Z.of_int l_1.size)
           (Ortac_runtime.Z.of_int (l_1.t).cap)
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "((integer_of_int  (l_1:'a l).size):integer <= (integer_of_int \n((l_1:'a l).t_3).cap):integer):prop";
                 term_kind = __position___049_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___048_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "((integer_of_int  (l_1:'a l).size):integer <= (integer_of_int \n((l_1:'a l).t_3).cap):integer):prop";
         position = __position___049_
       })
      |> (Ortac_runtime.Errors.register __error___048_)
let __invariant___056_ __error___057_ __position___058_ l_1 =
  if
    not
      (try
         Ortac_runtime.Z.gt (Ortac_runtime.Z.of_int (l_1.t).cap)
           (Ortac_runtime.Z.of_int 0)
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "((integer_of_int \n((l_1:'a l).t_3).cap):integer > 0:integer):prop";
                 term_kind = __position___058_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___057_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "((integer_of_int \n((l_1:'a l).t_3).cap):integer > 0:integer):prop";
         position = __position___058_
       })
      |> (Ortac_runtime.Errors.register __error___057_)
let __invariant___059_ __error___060_ __position___061_ l_1 =
  if
    not
      (try
         let __t1__062_ =
           Ortac_runtime.Z.leq
             (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1))
             (Ortac_runtime.Z.of_int (l_1.t).free) in
         let __t2__063_ =
           Ortac_runtime.Z.lt (Ortac_runtime.Z.of_int (l_1.t).free)
             (Ortac_runtime.Z.of_int (l_1.t).cap) in
         __t1__062_ && __t2__063_
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "((prefix -  1:integer):integer <= (integer_of_int \n((l_1:'a l).t_3).free):integer):prop /\\ ((integer_of_int \n((l_1:'a l).t_3).free):integer < (integer_of_int \n((l_1:'a l).t_3).cap):integer):prop";
                 term_kind = __position___061_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___060_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "((prefix -  1:integer):integer <= (integer_of_int \n((l_1:'a l).t_3).free):integer):prop /\\ ((integer_of_int \n((l_1:'a l).t_3).free):integer < (integer_of_int \n((l_1:'a l).t_3).cap):integer):prop";
         position = __position___061_
       })
      |> (Ortac_runtime.Errors.register __error___060_)
let __invariant___064_ __error___065_ __position___066_ l_1 =
  if
    not
      (try
         (not
            (not
               ((Ortac_runtime.Z.of_int (l_1.t).free) =
                  (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1)))))
           ||
           ((Ortac_runtime.Z.of_int
               (Ortac_runtime.Array.get (l_1.t).prev
                  (Ortac_runtime.Z.of_int (l_1.t).free)))
              = (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1)))
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "not ((integer_of_int  ((l_1:'a l).t_3).free):integer = (prefix - \n1:integer):integer):prop -> ((integer_of_int \n(get \n((l_1:'a l).t_3).prev (integer_of_int  ((l_1:'a l).t_3).free):integer):\nint):integer = (prefix - \n1:integer):integer):prop";
                 term_kind = __position___066_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___065_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "not ((integer_of_int  ((l_1:'a l).t_3).free):integer = (prefix - \n1:integer):integer):prop -> ((integer_of_int \n(get \n((l_1:'a l).t_3).prev (integer_of_int  ((l_1:'a l).t_3).free):integer):\nint):integer = (prefix - \n1:integer):integer):prop";
         position = __position___066_
       })
      |> (Ortac_runtime.Errors.register __error___065_)
let __invariant___067_ __error___068_ __position___069_ l_1 =
  if
    not
      (try
         Ortac_runtime.Z.forall (Ortac_runtime.Z.of_int 0)
           (Ortac_runtime.Z.pred (Ortac_runtime.Z.of_int (l_1.t).cap))
           (fun i_4 ->
              let __t1__070_ =
                Ortac_runtime.Z.leq
                  (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1))
                  (Ortac_runtime.Z.of_int
                     (Ortac_runtime.Array.get (l_1.t).next i_4)) in
              let __t2__071_ =
                Ortac_runtime.Z.lt
                  (Ortac_runtime.Z.of_int
                     (Ortac_runtime.Array.get (l_1.t).next i_4))
                  (Ortac_runtime.Z.of_int (l_1.t).cap) in
              __t1__070_ && __t2__071_)
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "forall i_4:integer. (0:integer <= i_4:integer):prop /\\ (i_4:integer < (integer_of_int \n((l_1:'a l).t_3).cap):integer):prop -> ((prefix - \n1:integer):integer <= (integer_of_int \n(get  ((l_1:'a l).t_3).next i_4:integer):int):integer):prop /\\ ((integer_of_int \n(get  ((l_1:'a l).t_3).next i_4:integer):int):integer < (integer_of_int \n((l_1:'a l).t_3).cap):integer):prop";
                 term_kind = __position___069_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___068_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "forall i_4:integer. (0:integer <= i_4:integer):prop /\\ (i_4:integer < (integer_of_int \n((l_1:'a l).t_3).cap):integer):prop -> ((prefix - \n1:integer):integer <= (integer_of_int \n(get  ((l_1:'a l).t_3).next i_4:integer):int):integer):prop /\\ ((integer_of_int \n(get  ((l_1:'a l).t_3).next i_4:integer):int):integer < (integer_of_int \n((l_1:'a l).t_3).cap):integer):prop";
         position = __position___069_
       })
      |> (Ortac_runtime.Errors.register __error___068_)
let __invariant___072_ __error___073_ __position___074_ l_1 =
  if
    not
      (try
         Ortac_runtime.Z.forall (Ortac_runtime.Z.of_int 0)
           (Ortac_runtime.Z.pred (Ortac_runtime.Z.of_int (l_1.t).cap))
           (fun i_5 ->
              let __t1__075_ =
                Ortac_runtime.Z.leq
                  (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1))
                  (Ortac_runtime.Z.of_int
                     (Ortac_runtime.Array.get (l_1.t).prev i_5)) in
              let __t2__076_ =
                Ortac_runtime.Z.lt
                  (Ortac_runtime.Z.of_int
                     (Ortac_runtime.Array.get (l_1.t).prev i_5))
                  (Ortac_runtime.Z.of_int (l_1.t).cap) in
              __t1__075_ && __t2__076_)
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "forall i_5:integer. (0:integer <= i_5:integer):prop /\\ (i_5:integer < (integer_of_int \n((l_1:'a l).t_3).cap):integer):prop -> ((prefix - \n1:integer):integer <= (integer_of_int \n(get  ((l_1:'a l).t_3).prev i_5:integer):int):integer):prop /\\ ((integer_of_int \n(get  ((l_1:'a l).t_3).prev i_5:integer):int):integer < (integer_of_int \n((l_1:'a l).t_3).cap):integer):prop";
                 term_kind = __position___074_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___073_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "forall i_5:integer. (0:integer <= i_5:integer):prop /\\ (i_5:integer < (integer_of_int \n((l_1:'a l).t_3).cap):integer):prop -> ((prefix - \n1:integer):integer <= (integer_of_int \n(get  ((l_1:'a l).t_3).prev i_5:integer):int):integer):prop /\\ ((integer_of_int \n(get  ((l_1:'a l).t_3).prev i_5:integer):int):integer < (integer_of_int \n((l_1:'a l).t_3).cap):integer):prop";
         position = __position___074_
       })
      |> (Ortac_runtime.Errors.register __error___073_)
let __invariant___077_ __error___078_ __position___079_ l_1 =
  if
    not
      (try
         Ortac_runtime.Z.forall (Ortac_runtime.Z.of_int 0)
           (Ortac_runtime.Z.pred (Ortac_runtime.Z.of_int (l_1.t).cap))
           (fun i_6 ->
              (not
                 (not
                    ((Ortac_runtime.Z.of_int
                        (Ortac_runtime.Array.get (l_1.t).next i_6))
                       = (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1)))))
                ||
                ((Ortac_runtime.Z.of_int
                    (Ortac_runtime.Array.get (l_1.t).prev
                       (Ortac_runtime.Z.of_int
                          (Ortac_runtime.Array.get (l_1.t).next i_6))))
                   = i_6))
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "forall i_6:integer. (0:integer <= i_6:integer):prop /\\ (i_6:integer < (integer_of_int \n((l_1:'a l).t_3).cap):integer):prop -> not ((integer_of_int \n(get  ((l_1:'a l).t_3).next i_6:integer):int):integer = (prefix - \n1:integer):integer):prop -> ((integer_of_int \n(get \n((l_1:'a l).t_3).prev (integer_of_int \n(get  ((l_1:'a l).t_3).next i_6:integer):int):integer):int):integer = \ni_6:integer):prop";
                 term_kind = __position___079_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___078_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "forall i_6:integer. (0:integer <= i_6:integer):prop /\\ (i_6:integer < (integer_of_int \n((l_1:'a l).t_3).cap):integer):prop -> not ((integer_of_int \n(get  ((l_1:'a l).t_3).next i_6:integer):int):integer = (prefix - \n1:integer):integer):prop -> ((integer_of_int \n(get \n((l_1:'a l).t_3).prev (integer_of_int \n(get  ((l_1:'a l).t_3).next i_6:integer):int):integer):int):integer = \ni_6:integer):prop";
         position = __position___079_
       })
      |> (Ortac_runtime.Errors.register __error___078_)
let __invariant___080_ __error___081_ __position___082_ l_1 =
  if
    not
      (try
         Ortac_runtime.Z.forall (Ortac_runtime.Z.of_int 0)
           (Ortac_runtime.Z.pred (Ortac_runtime.Z.of_int (l_1.t).cap))
           (fun i_7 ->
              (not
                 (not
                    ((Ortac_runtime.Z.of_int
                        (Ortac_runtime.Array.get (l_1.t).prev i_7))
                       = (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1)))))
                ||
                ((Ortac_runtime.Z.of_int
                    (Ortac_runtime.Array.get (l_1.t).next
                       (Ortac_runtime.Z.of_int
                          (Ortac_runtime.Array.get (l_1.t).prev i_7))))
                   = i_7))
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               {
                 term =
                   "forall i_7:integer. (0:integer <= i_7:integer):prop /\\ (i_7:integer < (integer_of_int \n((l_1:'a l).t_3).cap):integer):prop -> not ((integer_of_int \n(get  ((l_1:'a l).t_3).prev i_7:integer):int):integer = (prefix - \n1:integer):integer):prop -> ((integer_of_int \n(get \n((l_1:'a l).t_3).next (integer_of_int \n(get  ((l_1:'a l).t_3).prev i_7:integer):int):integer):int):integer = \ni_7:integer):prop";
                 term_kind = __position___082_;
                 exn = e
               })
              |> (Ortac_runtime.Errors.register __error___081_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       {
         term =
           "forall i_7:integer. (0:integer <= i_7:integer):prop /\\ (i_7:integer < (integer_of_int \n((l_1:'a l).t_3).cap):integer):prop -> not ((integer_of_int \n(get  ((l_1:'a l).t_3).prev i_7:integer):int):integer = (prefix - \n1:integer):integer):prop -> ((integer_of_int \n(get \n((l_1:'a l).t_3).next (integer_of_int \n(get  ((l_1:'a l).t_3).prev i_7:integer):int):integer):int):integer = \ni_7:integer):prop";
         position = __position___082_
       })
      |> (Ortac_runtime.Errors.register __error___081_)
let create cap_1 dummy =
  let __error__083_ =
    Ortac_runtime.Errors.create
      {
        Ortac_runtime.start =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 57;
            pos_bol = 2258;
            pos_cnum = 2258
          };
        Ortac_runtime.stop =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 59;
            pos_bol = 2390;
            pos_cnum = 2411
          }
      } "create" in
  Ortac_runtime.Errors.report __error__083_;
  (let t_4 =
     try create cap_1 dummy
     with
     | Invalid_argument _ as e ->
         ((if
             (try
                Ortac_runtime.Z.gt (Ortac_runtime.Z.of_int cap_1)
                  (Ortac_runtime.Z.of_int 0)
              with
              | e ->
                  ((Ortac_runtime.Specification_failure
                      {
                        term =
                          "((integer_of_int \ncap_1:int):integer > 0:integer):prop";
                        term_kind = Check;
                        exn = e
                      })
                     |> (Ortac_runtime.Errors.register __error__083_);
                   true))
           then
             (Ortac_runtime.Unexpected_checks { terms = [] }) |>
               (Ortac_runtime.Errors.register __error__083_);
           Ortac_runtime.Errors.report __error__083_);
          raise e)
     | Stack_overflow | Out_of_memory as e ->
         ((if
             not
               (try
                  Ortac_runtime.Z.gt (Ortac_runtime.Z.of_int cap_1)
                    (Ortac_runtime.Z.of_int 0)
                with
                | e ->
                    ((Ortac_runtime.Specification_failure
                        {
                          term =
                            "((integer_of_int \ncap_1:int):integer > 0:integer):prop";
                          term_kind = Check;
                          exn = e
                        })
                       |> (Ortac_runtime.Errors.register __error__083_);
                     true))
           then
             (Ortac_runtime.Uncaught_checks
                {
                  term =
                    "((integer_of_int \ncap_1:int):integer > 0:integer):prop"
                })
               |> (Ortac_runtime.Errors.register __error__083_);
           Ortac_runtime.Errors.report __error__083_);
          raise e)
     | e ->
         ((Ortac_runtime.Unexpected_exception { allowed_exn = []; exn = e })
            |> (Ortac_runtime.Errors.register __error__083_);
          (if
             not
               (try
                  Ortac_runtime.Z.gt (Ortac_runtime.Z.of_int cap_1)
                    (Ortac_runtime.Z.of_int 0)
                with
                | e ->
                    ((Ortac_runtime.Specification_failure
                        {
                          term =
                            "((integer_of_int \ncap_1:int):integer > 0:integer):prop";
                          term_kind = Check;
                          exn = e
                        })
                       |> (Ortac_runtime.Errors.register __error__083_);
                     true))
           then
             (Ortac_runtime.Uncaught_checks
                {
                  term =
                    "((integer_of_int \ncap_1:int):integer > 0:integer):prop"
                })
               |> (Ortac_runtime.Errors.register __error__083_);
           Ortac_runtime.Errors.report __error__083_);
          raise e) in
   if
     not
       (try
          Ortac_runtime.Z.gt (Ortac_runtime.Z.of_int cap_1)
            (Ortac_runtime.Z.of_int 0)
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                {
                  term =
                    "((integer_of_int \ncap_1:int):integer > 0:integer):prop";
                  term_kind = Check;
                  exn = e
                })
               |> (Ortac_runtime.Errors.register __error__083_);
             true))
   then
     (Ortac_runtime.Uncaught_checks
        { term = "((integer_of_int \ncap_1:int):integer > 0:integer):prop" })
       |> (Ortac_runtime.Errors.register __error__083_);
   __invariant___025_ __error__083_ Post t_4;
   __invariant___022_ __error__083_ Post t_4;
   __invariant___017_ __error__083_ Post t_4;
   __invariant___012_ __error__083_ Post t_4;
   __invariant___009_ __error__083_ Post t_4;
   __invariant___004_ __error__083_ Post t_4;
   __invariant___001_ __error__083_ Post t_4;
   Ortac_runtime.Errors.report __error__083_;
   t_4)
let create_list __arg0 =
  let __error__084_ =
    Ortac_runtime.Errors.create
      {
        Ortac_runtime.start =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 61;
            pos_bol = 2413;
            pos_cnum = 2413
          };
        Ortac_runtime.stop =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 61;
            pos_bol = 2413;
            pos_cnum = 2443
          }
      } "create_list" in
  __invariant___025_ __error__084_ Pre __arg0;
  __invariant___022_ __error__084_ Pre __arg0;
  __invariant___017_ __error__084_ Pre __arg0;
  __invariant___012_ __error__084_ Pre __arg0;
  __invariant___009_ __error__084_ Pre __arg0;
  __invariant___004_ __error__084_ Pre __arg0;
  __invariant___001_ __error__084_ Pre __arg0;
  Ortac_runtime.Errors.report __error__084_;
  (let result =
     try create_list __arg0
     with
     | Stack_overflow | Out_of_memory as e ->
         ((__invariant___025_ __error__084_ XPost __arg0;
           __invariant___022_ __error__084_ XPost __arg0;
           __invariant___017_ __error__084_ XPost __arg0;
           __invariant___012_ __error__084_ XPost __arg0;
           __invariant___009_ __error__084_ XPost __arg0;
           __invariant___004_ __error__084_ XPost __arg0;
           __invariant___001_ __error__084_ XPost __arg0;
           Ortac_runtime.Errors.report __error__084_);
          raise e)
     | e ->
         ((Ortac_runtime.Unexpected_exception { allowed_exn = []; exn = e })
            |> (Ortac_runtime.Errors.register __error__084_);
          (__invariant___025_ __error__084_ XPost __arg0;
           __invariant___022_ __error__084_ XPost __arg0;
           __invariant___017_ __error__084_ XPost __arg0;
           __invariant___012_ __error__084_ XPost __arg0;
           __invariant___009_ __error__084_ XPost __arg0;
           __invariant___004_ __error__084_ XPost __arg0;
           __invariant___001_ __error__084_ XPost __arg0;
           Ortac_runtime.Errors.report __error__084_);
          raise e) in
   __invariant___025_ __error__084_ Post __arg0;
   __invariant___022_ __error__084_ Post __arg0;
   __invariant___017_ __error__084_ Post __arg0;
   __invariant___012_ __error__084_ Post __arg0;
   __invariant___009_ __error__084_ Post __arg0;
   __invariant___004_ __error__084_ Post __arg0;
   __invariant___001_ __error__084_ Post __arg0;
   __invariant___080_ __error__084_ Post result;
   __invariant___077_ __error__084_ Post result;
   __invariant___072_ __error__084_ Post result;
   __invariant___067_ __error__084_ Post result;
   __invariant___064_ __error__084_ Post result;
   __invariant___059_ __error__084_ Post result;
   __invariant___056_ __error__084_ Post result;
   __invariant___047_ __error__084_ Post result;
   __invariant___042_ __error__084_ Post result;
   __invariant___037_ __error__084_ Post result;
   __invariant___034_ __error__084_ Post result;
   __invariant___031_ __error__084_ Post result;
   Ortac_runtime.Errors.report __error__084_;
   result)
let length __arg0_1 =
  let __error__085_ =
    Ortac_runtime.Errors.create
      {
        Ortac_runtime.start =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 62;
            pos_bol = 2444;
            pos_cnum = 2444
          };
        Ortac_runtime.stop =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 63;
            pos_bol = 2535;
            pos_cnum = 2546
          }
      } "length" in
  __invariant___080_ __error__085_ Pre __arg0_1;
  __invariant___077_ __error__085_ Pre __arg0_1;
  __invariant___072_ __error__085_ Pre __arg0_1;
  __invariant___067_ __error__085_ Pre __arg0_1;
  __invariant___064_ __error__085_ Pre __arg0_1;
  __invariant___059_ __error__085_ Pre __arg0_1;
  __invariant___056_ __error__085_ Pre __arg0_1;
  __invariant___047_ __error__085_ Pre __arg0_1;
  __invariant___042_ __error__085_ Pre __arg0_1;
  __invariant___037_ __error__085_ Pre __arg0_1;
  __invariant___034_ __error__085_ Pre __arg0_1;
  __invariant___031_ __error__085_ Pre __arg0_1;
  Ortac_runtime.Errors.report __error__085_;
  (let result_1 =
     try length __arg0_1
     with
     | Stack_overflow | Out_of_memory as e ->
         ((__invariant___080_ __error__085_ XPost __arg0_1;
           __invariant___077_ __error__085_ XPost __arg0_1;
           __invariant___072_ __error__085_ XPost __arg0_1;
           __invariant___067_ __error__085_ XPost __arg0_1;
           __invariant___064_ __error__085_ XPost __arg0_1;
           __invariant___059_ __error__085_ XPost __arg0_1;
           __invariant___056_ __error__085_ XPost __arg0_1;
           __invariant___047_ __error__085_ XPost __arg0_1;
           __invariant___042_ __error__085_ XPost __arg0_1;
           __invariant___037_ __error__085_ XPost __arg0_1;
           __invariant___034_ __error__085_ XPost __arg0_1;
           __invariant___031_ __error__085_ XPost __arg0_1;
           Ortac_runtime.Errors.report __error__085_);
          raise e)
     | e ->
         ((Ortac_runtime.Unexpected_exception { allowed_exn = []; exn = e })
            |> (Ortac_runtime.Errors.register __error__085_);
          (__invariant___080_ __error__085_ XPost __arg0_1;
           __invariant___077_ __error__085_ XPost __arg0_1;
           __invariant___072_ __error__085_ XPost __arg0_1;
           __invariant___067_ __error__085_ XPost __arg0_1;
           __invariant___064_ __error__085_ XPost __arg0_1;
           __invariant___059_ __error__085_ XPost __arg0_1;
           __invariant___056_ __error__085_ XPost __arg0_1;
           __invariant___047_ __error__085_ XPost __arg0_1;
           __invariant___042_ __error__085_ XPost __arg0_1;
           __invariant___037_ __error__085_ XPost __arg0_1;
           __invariant___034_ __error__085_ XPost __arg0_1;
           __invariant___031_ __error__085_ XPost __arg0_1;
           Ortac_runtime.Errors.report __error__085_);
          raise e) in
   __invariant___080_ __error__085_ Post __arg0_1;
   __invariant___077_ __error__085_ Post __arg0_1;
   __invariant___072_ __error__085_ Post __arg0_1;
   __invariant___067_ __error__085_ Post __arg0_1;
   __invariant___064_ __error__085_ Post __arg0_1;
   __invariant___059_ __error__085_ Post __arg0_1;
   __invariant___056_ __error__085_ Post __arg0_1;
   __invariant___047_ __error__085_ Post __arg0_1;
   __invariant___042_ __error__085_ Post __arg0_1;
   __invariant___037_ __error__085_ Post __arg0_1;
   __invariant___034_ __error__085_ Post __arg0_1;
   __invariant___031_ __error__085_ Post __arg0_1;
   Ortac_runtime.Errors.report __error__085_;
   result_1)
let is_empty l_2 =
  let __error__086_ =
    Ortac_runtime.Errors.create
      {
        Ortac_runtime.start =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 65;
            pos_bol = 2548;
            pos_cnum = 2548
          };
        Ortac_runtime.stop =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 68;
            pos_bol = 2690;
            pos_cnum = 2721
          }
      } "is_empty" in
  __invariant___080_ __error__086_ Pre l_2;
  __invariant___077_ __error__086_ Pre l_2;
  __invariant___072_ __error__086_ Pre l_2;
  __invariant___067_ __error__086_ Pre l_2;
  __invariant___064_ __error__086_ Pre l_2;
  __invariant___059_ __error__086_ Pre l_2;
  __invariant___056_ __error__086_ Pre l_2;
  __invariant___047_ __error__086_ Pre l_2;
  __invariant___042_ __error__086_ Pre l_2;
  __invariant___037_ __error__086_ Pre l_2;
  __invariant___034_ __error__086_ Pre l_2;
  __invariant___031_ __error__086_ Pre l_2;
  Ortac_runtime.Errors.report __error__086_;
  (let b =
     try is_empty l_2
     with
     | Stack_overflow | Out_of_memory as e ->
         ((__invariant___080_ __error__086_ XPost l_2;
           __invariant___077_ __error__086_ XPost l_2;
           __invariant___072_ __error__086_ XPost l_2;
           __invariant___067_ __error__086_ XPost l_2;
           __invariant___064_ __error__086_ XPost l_2;
           __invariant___059_ __error__086_ XPost l_2;
           __invariant___056_ __error__086_ XPost l_2;
           __invariant___047_ __error__086_ XPost l_2;
           __invariant___042_ __error__086_ XPost l_2;
           __invariant___037_ __error__086_ XPost l_2;
           __invariant___034_ __error__086_ XPost l_2;
           __invariant___031_ __error__086_ XPost l_2;
           Ortac_runtime.Errors.report __error__086_);
          raise e)
     | e ->
         ((Ortac_runtime.Unexpected_exception { allowed_exn = []; exn = e })
            |> (Ortac_runtime.Errors.register __error__086_);
          (__invariant___080_ __error__086_ XPost l_2;
           __invariant___077_ __error__086_ XPost l_2;
           __invariant___072_ __error__086_ XPost l_2;
           __invariant___067_ __error__086_ XPost l_2;
           __invariant___064_ __error__086_ XPost l_2;
           __invariant___059_ __error__086_ XPost l_2;
           __invariant___056_ __error__086_ XPost l_2;
           __invariant___047_ __error__086_ XPost l_2;
           __invariant___042_ __error__086_ XPost l_2;
           __invariant___037_ __error__086_ XPost l_2;
           __invariant___034_ __error__086_ XPost l_2;
           __invariant___031_ __error__086_ XPost l_2;
           Ortac_runtime.Errors.report __error__086_);
          raise e) in
   if
     not
       (try
          (b = true) =
            ((Ortac_runtime.Z.of_int l_2.size) = (Ortac_runtime.Z.of_int 0))
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                {
                  term =
                    "(b:bool = (True ):bool):prop <-> ((integer_of_int \n(l_2:'a l).size):integer = 0:integer):prop";
                  term_kind = Post;
                  exn = e
                })
               |> (Ortac_runtime.Errors.register __error__086_);
             true))
   then
     (Ortac_runtime.Violated_invariant
        {
          term =
            "(b:bool = (True ):bool):prop <-> ((integer_of_int \n(l_2:'a l).size):integer = 0:integer):prop";
          position = Post
        })
       |> (Ortac_runtime.Errors.register __error__086_);
   __invariant___080_ __error__086_ Post l_2;
   __invariant___077_ __error__086_ Post l_2;
   __invariant___072_ __error__086_ Post l_2;
   __invariant___067_ __error__086_ Post l_2;
   __invariant___064_ __error__086_ Post l_2;
   __invariant___059_ __error__086_ Post l_2;
   __invariant___056_ __error__086_ Post l_2;
   __invariant___047_ __error__086_ Post l_2;
   __invariant___042_ __error__086_ Post l_2;
   __invariant___037_ __error__086_ Post l_2;
   __invariant___034_ __error__086_ Post l_2;
   __invariant___031_ __error__086_ Post l_2;
   Ortac_runtime.Errors.report __error__086_;
   b)
let __logical_mem__087_ l_3 c_3 =
  let __t1__088_ = not ((is_empty l_3) = true) in
  let __t2__089_ = __logical_aux_mem__028_ l_3.t l_3.first c_3 in
  __t1__088_ && __t2__089_
let is_full l_4 =
  let __error__090_ =
    Ortac_runtime.Errors.create
      {
        Ortac_runtime.start =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 72;
            pos_bol = 2949;
            pos_cnum = 2949
          };
        Ortac_runtime.stop =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 75;
            pos_bol = 3092;
            pos_cnum = 3126
          }
      } "is_full" in
  __invariant___080_ __error__090_ Pre l_4;
  __invariant___077_ __error__090_ Pre l_4;
  __invariant___072_ __error__090_ Pre l_4;
  __invariant___067_ __error__090_ Pre l_4;
  __invariant___064_ __error__090_ Pre l_4;
  __invariant___059_ __error__090_ Pre l_4;
  __invariant___056_ __error__090_ Pre l_4;
  __invariant___047_ __error__090_ Pre l_4;
  __invariant___042_ __error__090_ Pre l_4;
  __invariant___037_ __error__090_ Pre l_4;
  __invariant___034_ __error__090_ Pre l_4;
  __invariant___031_ __error__090_ Pre l_4;
  Ortac_runtime.Errors.report __error__090_;
  (let b_1 =
     try is_full l_4
     with
     | Stack_overflow | Out_of_memory as e ->
         ((__invariant___080_ __error__090_ XPost l_4;
           __invariant___077_ __error__090_ XPost l_4;
           __invariant___072_ __error__090_ XPost l_4;
           __invariant___067_ __error__090_ XPost l_4;
           __invariant___064_ __error__090_ XPost l_4;
           __invariant___059_ __error__090_ XPost l_4;
           __invariant___056_ __error__090_ XPost l_4;
           __invariant___047_ __error__090_ XPost l_4;
           __invariant___042_ __error__090_ XPost l_4;
           __invariant___037_ __error__090_ XPost l_4;
           __invariant___034_ __error__090_ XPost l_4;
           __invariant___031_ __error__090_ XPost l_4;
           Ortac_runtime.Errors.report __error__090_);
          raise e)
     | e ->
         ((Ortac_runtime.Unexpected_exception { allowed_exn = []; exn = e })
            |> (Ortac_runtime.Errors.register __error__090_);
          (__invariant___080_ __error__090_ XPost l_4;
           __invariant___077_ __error__090_ XPost l_4;
           __invariant___072_ __error__090_ XPost l_4;
           __invariant___067_ __error__090_ XPost l_4;
           __invariant___064_ __error__090_ XPost l_4;
           __invariant___059_ __error__090_ XPost l_4;
           __invariant___056_ __error__090_ XPost l_4;
           __invariant___047_ __error__090_ XPost l_4;
           __invariant___042_ __error__090_ XPost l_4;
           __invariant___037_ __error__090_ XPost l_4;
           __invariant___034_ __error__090_ XPost l_4;
           __invariant___031_ __error__090_ XPost l_4;
           Ortac_runtime.Errors.report __error__090_);
          raise e) in
   if
     not
       (try
          (b_1 = true) =
            ((Ortac_runtime.Z.of_int (l_4.t).free) =
               (Ortac_runtime.Z.neg (Ortac_runtime.Z.of_int 1)))
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                {
                  term =
                    "(b_1:bool = (True ):bool):prop <-> ((integer_of_int \n((l_4:'a l).t_3).free):integer = (prefix - \n1:integer):integer):prop";
                  term_kind = Post;
                  exn = e
                })
               |> (Ortac_runtime.Errors.register __error__090_);
             true))
   then
     (Ortac_runtime.Violated_invariant
        {
          term =
            "(b_1:bool = (True ):bool):prop <-> ((integer_of_int \n((l_4:'a l).t_3).free):integer = (prefix - \n1:integer):integer):prop";
          position = Post
        })
       |> (Ortac_runtime.Errors.register __error__090_);
   __invariant___080_ __error__090_ Post l_4;
   __invariant___077_ __error__090_ Post l_4;
   __invariant___072_ __error__090_ Post l_4;
   __invariant___067_ __error__090_ Post l_4;
   __invariant___064_ __error__090_ Post l_4;
   __invariant___059_ __error__090_ Post l_4;
   __invariant___056_ __error__090_ Post l_4;
   __invariant___047_ __error__090_ Post l_4;
   __invariant___042_ __error__090_ Post l_4;
   __invariant___037_ __error__090_ Post l_4;
   __invariant___034_ __error__090_ Post l_4;
   __invariant___031_ __error__090_ Post l_4;
   Ortac_runtime.Errors.report __error__090_;
   b_1)
let get l_5 c_4 =
  let __error__091_ =
    Ortac_runtime.Errors.create
      {
        Ortac_runtime.start =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 77;
            pos_bol = 3128;
            pos_cnum = 3128
          };
        Ortac_runtime.stop =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 81;
            pos_bol = 3293;
            pos_cnum = 3328
          }
      } "get" in
  if
    not
      (try __logical_mem__087_ l_5 c_4
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               { term = "t.conte"; term_kind = Pre; exn = e })
              |> (Ortac_runtime.Errors.register __error__091_);
            true))
  then
    (Ortac_runtime.Violated_invariant { term = "t.conte"; position = Pre })
      |> (Ortac_runtime.Errors.register __error__091_);
  __invariant___080_ __error__091_ Pre l_5;
  __invariant___077_ __error__091_ Pre l_5;
  __invariant___072_ __error__091_ Pre l_5;
  __invariant___067_ __error__091_ Pre l_5;
  __invariant___064_ __error__091_ Pre l_5;
  __invariant___059_ __error__091_ Pre l_5;
  __invariant___056_ __error__091_ Pre l_5;
  __invariant___047_ __error__091_ Pre l_5;
  __invariant___042_ __error__091_ Pre l_5;
  __invariant___037_ __error__091_ Pre l_5;
  __invariant___034_ __error__091_ Pre l_5;
  __invariant___031_ __error__091_ Pre l_5;
  Ortac_runtime.Errors.report __error__091_;
  (let v =
     try get l_5 c_4
     with
     | Stack_overflow | Out_of_memory as e ->
         ((__invariant___080_ __error__091_ XPost l_5;
           __invariant___077_ __error__091_ XPost l_5;
           __invariant___072_ __error__091_ XPost l_5;
           __invariant___067_ __error__091_ XPost l_5;
           __invariant___064_ __error__091_ XPost l_5;
           __invariant___059_ __error__091_ XPost l_5;
           __invariant___056_ __error__091_ XPost l_5;
           __invariant___047_ __error__091_ XPost l_5;
           __invariant___042_ __error__091_ XPost l_5;
           __invariant___037_ __error__091_ XPost l_5;
           __invariant___034_ __error__091_ XPost l_5;
           __invariant___031_ __error__091_ XPost l_5;
           Ortac_runtime.Errors.report __error__091_);
          raise e)
     | e ->
         ((Ortac_runtime.Unexpected_exception { allowed_exn = []; exn = e })
            |> (Ortac_runtime.Errors.register __error__091_);
          (__invariant___080_ __error__091_ XPost l_5;
           __invariant___077_ __error__091_ XPost l_5;
           __invariant___072_ __error__091_ XPost l_5;
           __invariant___067_ __error__091_ XPost l_5;
           __invariant___064_ __error__091_ XPost l_5;
           __invariant___059_ __error__091_ XPost l_5;
           __invariant___056_ __error__091_ XPost l_5;
           __invariant___047_ __error__091_ XPost l_5;
           __invariant___042_ __error__091_ XPost l_5;
           __invariant___037_ __error__091_ XPost l_5;
           __invariant___034_ __error__091_ XPost l_5;
           __invariant___031_ __error__091_ XPost l_5;
           Ortac_runtime.Errors.report __error__091_);
          raise e) in
   if
     not
       (try
          v =
            (Ortac_runtime.Array.get (l_5.t).contents
               (Ortac_runtime.Z.of_int c_4))
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                {
                  term =
                    "(v:'a = (get \n((l_5:'a l).t_3).contents (integer_of_int  c_4:int):integer):'a):prop";
                  term_kind = Post;
                  exn = e
                })
               |> (Ortac_runtime.Errors.register __error__091_);
             true))
   then
     (Ortac_runtime.Violated_invariant
        {
          term =
            "(v:'a = (get \n((l_5:'a l).t_3).contents (integer_of_int  c_4:int):integer):'a):prop";
          position = Post
        })
       |> (Ortac_runtime.Errors.register __error__091_);
   __invariant___080_ __error__091_ Post l_5;
   __invariant___077_ __error__091_ Post l_5;
   __invariant___072_ __error__091_ Post l_5;
   __invariant___067_ __error__091_ Post l_5;
   __invariant___064_ __error__091_ Post l_5;
   __invariant___059_ __error__091_ Post l_5;
   __invariant___056_ __error__091_ Post l_5;
   __invariant___047_ __error__091_ Post l_5;
   __invariant___042_ __error__091_ Post l_5;
   __invariant___037_ __error__091_ Post l_5;
   __invariant___034_ __error__091_ Post l_5;
   __invariant___031_ __error__091_ Post l_5;
   Ortac_runtime.Errors.report __error__091_;
   v)
let ends l_6 =
  let __error__092_ =
    Ortac_runtime.Errors.create
      {
        Ortac_runtime.start =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 83;
            pos_bol = 3330;
            pos_cnum = 3330
          };
        Ortac_runtime.stop =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 88;
            pos_bol = 3532;
            pos_cnum = 3559
          }
      } "ends" in
  if
    not
      (try not ((is_empty l_6) = true)
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               { term = "es fst = l.first"; term_kind = Pre; exn = e })
              |> (Ortac_runtime.Errors.register __error__092_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       { term = "es fst = l.first"; position = Pre })
      |> (Ortac_runtime.Errors.register __error__092_);
  __invariant___080_ __error__092_ Pre l_6;
  __invariant___077_ __error__092_ Pre l_6;
  __invariant___072_ __error__092_ Pre l_6;
  __invariant___067_ __error__092_ Pre l_6;
  __invariant___064_ __error__092_ Pre l_6;
  __invariant___059_ __error__092_ Pre l_6;
  __invariant___056_ __error__092_ Pre l_6;
  __invariant___047_ __error__092_ Pre l_6;
  __invariant___042_ __error__092_ Pre l_6;
  __invariant___037_ __error__092_ Pre l_6;
  __invariant___034_ __error__092_ Pre l_6;
  __invariant___031_ __error__092_ Pre l_6;
  Ortac_runtime.Errors.report __error__092_;
  (let (fst, lst) =
     try ends l_6
     with
     | Stack_overflow | Out_of_memory as e ->
         ((__invariant___080_ __error__092_ XPost l_6;
           __invariant___077_ __error__092_ XPost l_6;
           __invariant___072_ __error__092_ XPost l_6;
           __invariant___067_ __error__092_ XPost l_6;
           __invariant___064_ __error__092_ XPost l_6;
           __invariant___059_ __error__092_ XPost l_6;
           __invariant___056_ __error__092_ XPost l_6;
           __invariant___047_ __error__092_ XPost l_6;
           __invariant___042_ __error__092_ XPost l_6;
           __invariant___037_ __error__092_ XPost l_6;
           __invariant___034_ __error__092_ XPost l_6;
           __invariant___031_ __error__092_ XPost l_6;
           Ortac_runtime.Errors.report __error__092_);
          raise e)
     | e ->
         ((Ortac_runtime.Unexpected_exception { allowed_exn = []; exn = e })
            |> (Ortac_runtime.Errors.register __error__092_);
          (__invariant___080_ __error__092_ XPost l_6;
           __invariant___077_ __error__092_ XPost l_6;
           __invariant___072_ __error__092_ XPost l_6;
           __invariant___067_ __error__092_ XPost l_6;
           __invariant___064_ __error__092_ XPost l_6;
           __invariant___059_ __error__092_ XPost l_6;
           __invariant___056_ __error__092_ XPost l_6;
           __invariant___047_ __error__092_ XPost l_6;
           __invariant___042_ __error__092_ XPost l_6;
           __invariant___037_ __error__092_ XPost l_6;
           __invariant___034_ __error__092_ XPost l_6;
           __invariant___031_ __error__092_ XPost l_6;
           Ortac_runtime.Errors.report __error__092_);
          raise e) in
   if
     not
       (try lst = l_6.last
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                {
                  term = "(lst:int = (l_6:'a l).last):prop";
                  term_kind = Post;
                  exn = e
                })
               |> (Ortac_runtime.Errors.register __error__092_);
             true))
   then
     (Ortac_runtime.Violated_invariant
        { term = "(lst:int = (l_6:'a l).last):prop"; position = Post })
       |> (Ortac_runtime.Errors.register __error__092_);
   if
     not
       (try fst = l_6.first
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                {
                  term = "(fst:int = (l_6:'a l).first):prop";
                  term_kind = Post;
                  exn = e
                })
               |> (Ortac_runtime.Errors.register __error__092_);
             true))
   then
     (Ortac_runtime.Violated_invariant
        { term = "(fst:int = (l_6:'a l).first):prop"; position = Post })
       |> (Ortac_runtime.Errors.register __error__092_);
   __invariant___080_ __error__092_ Post l_6;
   __invariant___077_ __error__092_ Post l_6;
   __invariant___072_ __error__092_ Post l_6;
   __invariant___067_ __error__092_ Post l_6;
   __invariant___064_ __error__092_ Post l_6;
   __invariant___059_ __error__092_ Post l_6;
   __invariant___056_ __error__092_ Post l_6;
   __invariant___047_ __error__092_ Post l_6;
   __invariant___042_ __error__092_ Post l_6;
   __invariant___037_ __error__092_ Post l_6;
   __invariant___034_ __error__092_ Post l_6;
   __invariant___031_ __error__092_ Post l_6;
   Ortac_runtime.Errors.report __error__092_;
   (fst, lst))
let next l_7 i_8 =
  let __error__093_ =
    Ortac_runtime.Errors.create
      {
        Ortac_runtime.start =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 90;
            pos_bol = 3561;
            pos_cnum = 3561
          };
        Ortac_runtime.stop =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 95;
            pos_bol = 3772;
            pos_cnum = 3818
          }
      } "next" in
  __invariant___080_ __error__093_ Pre l_7;
  __invariant___077_ __error__093_ Pre l_7;
  __invariant___072_ __error__093_ Pre l_7;
  __invariant___067_ __error__093_ Pre l_7;
  __invariant___064_ __error__093_ Pre l_7;
  __invariant___059_ __error__093_ Pre l_7;
  __invariant___056_ __error__093_ Pre l_7;
  __invariant___047_ __error__093_ Pre l_7;
  __invariant___042_ __error__093_ Pre l_7;
  __invariant___037_ __error__093_ Pre l_7;
  __invariant___034_ __error__093_ Pre l_7;
  __invariant___031_ __error__093_ Pre l_7;
  Ortac_runtime.Errors.report __error__093_;
  (let c_5 =
     try next l_7 i_8
     with
     | Stack_overflow | Out_of_memory as e ->
         ((__invariant___080_ __error__093_ XPost l_7;
           __invariant___077_ __error__093_ XPost l_7;
           __invariant___072_ __error__093_ XPost l_7;
           __invariant___067_ __error__093_ XPost l_7;
           __invariant___064_ __error__093_ XPost l_7;
           __invariant___059_ __error__093_ XPost l_7;
           __invariant___056_ __error__093_ XPost l_7;
           __invariant___047_ __error__093_ XPost l_7;
           __invariant___042_ __error__093_ XPost l_7;
           __invariant___037_ __error__093_ XPost l_7;
           __invariant___034_ __error__093_ XPost l_7;
           __invariant___031_ __error__093_ XPost l_7;
           Ortac_runtime.Errors.report __error__093_);
          raise e)
     | e ->
         ((Ortac_runtime.Unexpected_exception { allowed_exn = []; exn = e })
            |> (Ortac_runtime.Errors.register __error__093_);
          (__invariant___080_ __error__093_ XPost l_7;
           __invariant___077_ __error__093_ XPost l_7;
           __invariant___072_ __error__093_ XPost l_7;
           __invariant___067_ __error__093_ XPost l_7;
           __invariant___064_ __error__093_ XPost l_7;
           __invariant___059_ __error__093_ XPost l_7;
           __invariant___056_ __error__093_ XPost l_7;
           __invariant___047_ __error__093_ XPost l_7;
           __invariant___042_ __error__093_ XPost l_7;
           __invariant___037_ __error__093_ XPost l_7;
           __invariant___034_ __error__093_ XPost l_7;
           __invariant___031_ __error__093_ XPost l_7;
           Ortac_runtime.Errors.report __error__093_);
          raise e) in
   if
     not
       (try
          (not (not (i_8 = l_7.last))) ||
            (c_5 =
               (Ortac_runtime.Array.get (l_7.t).next
                  (Ortac_runtime.Z.of_int i_8)))
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                {
                  term =
                    "not (i_8:int = (l_7:'a l).last):prop -> (c_5:int = (get \n((l_7:'a l).t_3).next (integer_of_int  i_8:int):integer):int):prop";
                  term_kind = Post;
                  exn = e
                })
               |> (Ortac_runtime.Errors.register __error__093_);
             true))
   then
     (Ortac_runtime.Violated_invariant
        {
          term =
            "not (i_8:int = (l_7:'a l).last):prop -> (c_5:int = (get \n((l_7:'a l).t_3).next (integer_of_int  i_8:int):integer):int):prop";
          position = Post
        })
       |> (Ortac_runtime.Errors.register __error__093_);
   if
     not
       (try (not (i_8 = l_7.last)) || (c_5 = i_8)
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                { term = "> l.last -> c = l.t"; term_kind = Post; exn = e })
               |> (Ortac_runtime.Errors.register __error__093_);
             true))
   then
     (Ortac_runtime.Violated_invariant
        { term = "> l.last -> c = l.t"; position = Post })
       |> (Ortac_runtime.Errors.register __error__093_);
   if
     not
       (try __logical_mem__087_ l_7 i_8
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                { term = "last ->"; term_kind = Post; exn = e })
               |> (Ortac_runtime.Errors.register __error__093_);
             true))
   then
     (Ortac_runtime.Violated_invariant { term = "last ->"; position = Post })
       |> (Ortac_runtime.Errors.register __error__093_);
   __invariant___080_ __error__093_ Post l_7;
   __invariant___077_ __error__093_ Post l_7;
   __invariant___072_ __error__093_ Post l_7;
   __invariant___067_ __error__093_ Post l_7;
   __invariant___064_ __error__093_ Post l_7;
   __invariant___059_ __error__093_ Post l_7;
   __invariant___056_ __error__093_ Post l_7;
   __invariant___047_ __error__093_ Post l_7;
   __invariant___042_ __error__093_ Post l_7;
   __invariant___037_ __error__093_ Post l_7;
   __invariant___034_ __error__093_ Post l_7;
   __invariant___031_ __error__093_ Post l_7;
   Ortac_runtime.Errors.report __error__093_;
   c_5)
let promote l_8 i_9 =
  let __error__094_ =
    Ortac_runtime.Errors.create
      {
        Ortac_runtime.start =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 97;
            pos_bol = 3820;
            pos_cnum = 3820
          };
        Ortac_runtime.stop =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 102;
            pos_bol = 3989;
            pos_cnum = 3991
          }
      } "promote" in
  if
    not
      (try __logical_mem__087_ l_8 i_9
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               { term = "mem l c"; term_kind = Pre; exn = e })
              |> (Ortac_runtime.Errors.register __error__094_);
            true))
  then
    (Ortac_runtime.Violated_invariant { term = "mem l c"; position = Pre })
      |> (Ortac_runtime.Errors.register __error__094_);
  __invariant___080_ __error__094_ Pre l_8;
  __invariant___077_ __error__094_ Pre l_8;
  __invariant___072_ __error__094_ Pre l_8;
  __invariant___067_ __error__094_ Pre l_8;
  __invariant___064_ __error__094_ Pre l_8;
  __invariant___059_ __error__094_ Pre l_8;
  __invariant___056_ __error__094_ Pre l_8;
  __invariant___047_ __error__094_ Pre l_8;
  __invariant___042_ __error__094_ Pre l_8;
  __invariant___037_ __error__094_ Pre l_8;
  __invariant___034_ __error__094_ Pre l_8;
  __invariant___031_ __error__094_ Pre l_8;
  Ortac_runtime.Errors.report __error__094_;
  (let c_6 =
     try promote l_8 i_9
     with
     | Stack_overflow | Out_of_memory as e ->
         ((__invariant___080_ __error__094_ XPost l_8;
           __invariant___077_ __error__094_ XPost l_8;
           __invariant___072_ __error__094_ XPost l_8;
           __invariant___067_ __error__094_ XPost l_8;
           __invariant___064_ __error__094_ XPost l_8;
           __invariant___059_ __error__094_ XPost l_8;
           __invariant___056_ __error__094_ XPost l_8;
           __invariant___047_ __error__094_ XPost l_8;
           __invariant___042_ __error__094_ XPost l_8;
           __invariant___037_ __error__094_ XPost l_8;
           __invariant___034_ __error__094_ XPost l_8;
           __invariant___031_ __error__094_ XPost l_8;
           Ortac_runtime.Errors.report __error__094_);
          raise e)
     | e ->
         ((Ortac_runtime.Unexpected_exception { allowed_exn = []; exn = e })
            |> (Ortac_runtime.Errors.register __error__094_);
          (__invariant___080_ __error__094_ XPost l_8;
           __invariant___077_ __error__094_ XPost l_8;
           __invariant___072_ __error__094_ XPost l_8;
           __invariant___067_ __error__094_ XPost l_8;
           __invariant___064_ __error__094_ XPost l_8;
           __invariant___059_ __error__094_ XPost l_8;
           __invariant___056_ __error__094_ XPost l_8;
           __invariant___047_ __error__094_ XPost l_8;
           __invariant___042_ __error__094_ XPost l_8;
           __invariant___037_ __error__094_ XPost l_8;
           __invariant___034_ __error__094_ XPost l_8;
           __invariant___031_ __error__094_ XPost l_8;
           Ortac_runtime.Errors.report __error__094_);
          raise e) in
   if
     not
       (try __logical_mem__087_ l_8 c_6
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                {
                  term = "(mem \nl_8:'a l c_6:int):prop";
                  term_kind = Post;
                  exn = e
                })
               |> (Ortac_runtime.Errors.register __error__094_);
             true))
   then
     (Ortac_runtime.Violated_invariant
        { term = "(mem \nl_8:'a l c_6:int):prop"; position = Post })
       |> (Ortac_runtime.Errors.register __error__094_);
   __invariant___080_ __error__094_ Post l_8;
   __invariant___077_ __error__094_ Post l_8;
   __invariant___072_ __error__094_ Post l_8;
   __invariant___067_ __error__094_ Post l_8;
   __invariant___064_ __error__094_ Post l_8;
   __invariant___059_ __error__094_ Post l_8;
   __invariant___056_ __error__094_ Post l_8;
   __invariant___047_ __error__094_ Post l_8;
   __invariant___042_ __error__094_ Post l_8;
   __invariant___037_ __error__094_ Post l_8;
   __invariant___034_ __error__094_ Post l_8;
   __invariant___031_ __error__094_ Post l_8;
   Ortac_runtime.Errors.report __error__094_;
   c_6)
let append l_9 v_1 =
  let __error__095_ =
    Ortac_runtime.Errors.create
      {
        Ortac_runtime.start =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 104;
            pos_bol = 3993;
            pos_cnum = 3993
          };
        Ortac_runtime.stop =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 119;
            pos_bol = 4517;
            pos_cnum = 4519
          }
      } "append" in
  __invariant___080_ __error__095_ Pre l_9;
  __invariant___077_ __error__095_ Pre l_9;
  __invariant___072_ __error__095_ Pre l_9;
  __invariant___067_ __error__095_ Pre l_9;
  __invariant___064_ __error__095_ Pre l_9;
  __invariant___059_ __error__095_ Pre l_9;
  __invariant___056_ __error__095_ Pre l_9;
  __invariant___047_ __error__095_ Pre l_9;
  __invariant___042_ __error__095_ Pre l_9;
  __invariant___037_ __error__095_ Pre l_9;
  __invariant___034_ __error__095_ Pre l_9;
  __invariant___031_ __error__095_ Pre l_9;
  Ortac_runtime.Errors.report __error__095_;
  (let (c_7, removed) =
     try append l_9 v_1
     with
     | Stack_overflow | Out_of_memory as e ->
         ((__invariant___080_ __error__095_ XPost l_9;
           __invariant___077_ __error__095_ XPost l_9;
           __invariant___072_ __error__095_ XPost l_9;
           __invariant___067_ __error__095_ XPost l_9;
           __invariant___064_ __error__095_ XPost l_9;
           __invariant___059_ __error__095_ XPost l_9;
           __invariant___056_ __error__095_ XPost l_9;
           __invariant___047_ __error__095_ XPost l_9;
           __invariant___042_ __error__095_ XPost l_9;
           __invariant___037_ __error__095_ XPost l_9;
           __invariant___034_ __error__095_ XPost l_9;
           __invariant___031_ __error__095_ XPost l_9;
           Ortac_runtime.Errors.report __error__095_);
          raise e)
     | e ->
         ((Ortac_runtime.Unexpected_exception { allowed_exn = []; exn = e })
            |> (Ortac_runtime.Errors.register __error__095_);
          (__invariant___080_ __error__095_ XPost l_9;
           __invariant___077_ __error__095_ XPost l_9;
           __invariant___072_ __error__095_ XPost l_9;
           __invariant___067_ __error__095_ XPost l_9;
           __invariant___064_ __error__095_ XPost l_9;
           __invariant___059_ __error__095_ XPost l_9;
           __invariant___056_ __error__095_ XPost l_9;
           __invariant___047_ __error__095_ XPost l_9;
           __invariant___042_ __error__095_ XPost l_9;
           __invariant___037_ __error__095_ XPost l_9;
           __invariant___034_ __error__095_ XPost l_9;
           __invariant___031_ __error__095_ XPost l_9;
           Ortac_runtime.Errors.report __error__095_);
          raise e) in
   if
     not
       (try __logical_mem__087_ l_9 c_7
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                {
                  term = "(mem \nl_9:'a l c_7:int):prop";
                  term_kind = Post;
                  exn = e
                })
               |> (Ortac_runtime.Errors.register __error__095_);
             true))
   then
     (Ortac_runtime.Violated_invariant
        { term = "(mem \nl_9:'a l c_7:int):prop"; position = Post })
       |> (Ortac_runtime.Errors.register __error__095_);
   if
     not
       (try c_7 = l_9.last
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                { term = " with\n    "; term_kind = Post; exn = e })
               |> (Ortac_runtime.Errors.register __error__095_);
             true))
   then
     (Ortac_runtime.Violated_invariant
        { term = " with\n    "; position = Post })
       |> (Ortac_runtime.Errors.register __error__095_);
   __invariant___080_ __error__095_ Post l_9;
   __invariant___077_ __error__095_ Post l_9;
   __invariant___072_ __error__095_ Post l_9;
   __invariant___067_ __error__095_ Post l_9;
   __invariant___064_ __error__095_ Post l_9;
   __invariant___059_ __error__095_ Post l_9;
   __invariant___056_ __error__095_ Post l_9;
   __invariant___047_ __error__095_ Post l_9;
   __invariant___042_ __error__095_ Post l_9;
   __invariant___037_ __error__095_ Post l_9;
   __invariant___034_ __error__095_ Post l_9;
   __invariant___031_ __error__095_ Post l_9;
   Ortac_runtime.Errors.report __error__095_;
   (c_7, removed))
let append_before l_10 i_10 v_2 =
  let __error__098_ =
    Ortac_runtime.Errors.create
      {
        Ortac_runtime.start =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 121;
            pos_bol = 4521;
            pos_cnum = 4521
          };
        Ortac_runtime.stop =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 130;
            pos_bol = 4845;
            pos_cnum = 4847
          }
      } "append_before" in
  if
    not
      (try __logical_mem__087_ l_10 i_10
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               { term = " = old "; term_kind = Pre; exn = e })
              |> (Ortac_runtime.Errors.register __error__098_);
            true))
  then
    (Ortac_runtime.Violated_invariant { term = " = old "; position = Pre })
      |> (Ortac_runtime.Errors.register __error__098_);
  if
    not
      (try not ((is_full l_10) = true)
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               { term = "\n    modifies l"; term_kind = Pre; exn = e })
              |> (Ortac_runtime.Errors.register __error__098_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       { term = "\n    modifies l"; position = Pre })
      |> (Ortac_runtime.Errors.register __error__098_);
  __invariant___080_ __error__098_ Pre l_10;
  __invariant___077_ __error__098_ Pre l_10;
  __invariant___072_ __error__098_ Pre l_10;
  __invariant___067_ __error__098_ Pre l_10;
  __invariant___064_ __error__098_ Pre l_10;
  __invariant___059_ __error__098_ Pre l_10;
  __invariant___056_ __error__098_ Pre l_10;
  __invariant___047_ __error__098_ Pre l_10;
  __invariant___042_ __error__098_ Pre l_10;
  __invariant___037_ __error__098_ Pre l_10;
  __invariant___034_ __error__098_ Pre l_10;
  __invariant___031_ __error__098_ Pre l_10;
  Ortac_runtime.Errors.report __error__098_;
  (let c_8 =
     try append_before l_10 i_10 v_2
     with
     | Stack_overflow | Out_of_memory as e ->
         ((__invariant___080_ __error__098_ XPost l_10;
           __invariant___077_ __error__098_ XPost l_10;
           __invariant___072_ __error__098_ XPost l_10;
           __invariant___067_ __error__098_ XPost l_10;
           __invariant___064_ __error__098_ XPost l_10;
           __invariant___059_ __error__098_ XPost l_10;
           __invariant___056_ __error__098_ XPost l_10;
           __invariant___047_ __error__098_ XPost l_10;
           __invariant___042_ __error__098_ XPost l_10;
           __invariant___037_ __error__098_ XPost l_10;
           __invariant___034_ __error__098_ XPost l_10;
           __invariant___031_ __error__098_ XPost l_10;
           Ortac_runtime.Errors.report __error__098_);
          raise e)
     | e ->
         ((Ortac_runtime.Unexpected_exception { allowed_exn = []; exn = e })
            |> (Ortac_runtime.Errors.register __error__098_);
          (__invariant___080_ __error__098_ XPost l_10;
           __invariant___077_ __error__098_ XPost l_10;
           __invariant___072_ __error__098_ XPost l_10;
           __invariant___067_ __error__098_ XPost l_10;
           __invariant___064_ __error__098_ XPost l_10;
           __invariant___059_ __error__098_ XPost l_10;
           __invariant___056_ __error__098_ XPost l_10;
           __invariant___047_ __error__098_ XPost l_10;
           __invariant___042_ __error__098_ XPost l_10;
           __invariant___037_ __error__098_ XPost l_10;
           __invariant___034_ __error__098_ XPost l_10;
           __invariant___031_ __error__098_ XPost l_10;
           Ortac_runtime.Errors.report __error__098_);
          raise e) in
   if
     not
       (try __logical_mem__087_ l_10 c_8
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                {
                  term = "(mem \nl_10:'a l c_8:int):prop";
                  term_kind = Post;
                  exn = e
                })
               |> (Ortac_runtime.Errors.register __error__098_);
             true))
   then
     (Ortac_runtime.Violated_invariant
        { term = "(mem \nl_10:'a l c_8:int):prop"; position = Post })
       |> (Ortac_runtime.Errors.register __error__098_);
   if
     not
       (try
          (Ortac_runtime.Array.get (l_10.t).next (Ortac_runtime.Z.of_int c_8))
            = i_10
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                { term = " (l.first) -> c "; term_kind = Post; exn = e })
               |> (Ortac_runtime.Errors.register __error__098_);
             true))
   then
     (Ortac_runtime.Violated_invariant
        { term = " (l.first) -> c "; position = Post })
       |> (Ortac_runtime.Errors.register __error__098_);
   __invariant___080_ __error__098_ Post l_10;
   __invariant___077_ __error__098_ Post l_10;
   __invariant___072_ __error__098_ Post l_10;
   __invariant___067_ __error__098_ Post l_10;
   __invariant___064_ __error__098_ Post l_10;
   __invariant___059_ __error__098_ Post l_10;
   __invariant___056_ __error__098_ Post l_10;
   __invariant___047_ __error__098_ Post l_10;
   __invariant___042_ __error__098_ Post l_10;
   __invariant___037_ __error__098_ Post l_10;
   __invariant___034_ __error__098_ Post l_10;
   __invariant___031_ __error__098_ Post l_10;
   Ortac_runtime.Errors.report __error__098_;
   c_8)
let append_after l_11 i_11 v_3 =
  let __error__099_ =
    Ortac_runtime.Errors.create
      {
        Ortac_runtime.start =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 132;
            pos_bol = 4849;
            pos_cnum = 4849
          };
        Ortac_runtime.stop =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 141;
            pos_bol = 5169;
            pos_cnum = 5171
          }
      } "append_after" in
  if
    not
      (try __logical_mem__087_ l_11 i_11
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               { term = " = old "; term_kind = Pre; exn = e })
              |> (Ortac_runtime.Errors.register __error__099_);
            true))
  then
    (Ortac_runtime.Violated_invariant { term = " = old "; position = Pre })
      |> (Ortac_runtime.Errors.register __error__099_);
  if
    not
      (try not ((is_full l_11) = true)
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               { term = "\n    modifies l"; term_kind = Pre; exn = e })
              |> (Ortac_runtime.Errors.register __error__099_);
            true))
  then
    (Ortac_runtime.Violated_invariant
       { term = "\n    modifies l"; position = Pre })
      |> (Ortac_runtime.Errors.register __error__099_);
  __invariant___080_ __error__099_ Pre l_11;
  __invariant___077_ __error__099_ Pre l_11;
  __invariant___072_ __error__099_ Pre l_11;
  __invariant___067_ __error__099_ Pre l_11;
  __invariant___064_ __error__099_ Pre l_11;
  __invariant___059_ __error__099_ Pre l_11;
  __invariant___056_ __error__099_ Pre l_11;
  __invariant___047_ __error__099_ Pre l_11;
  __invariant___042_ __error__099_ Pre l_11;
  __invariant___037_ __error__099_ Pre l_11;
  __invariant___034_ __error__099_ Pre l_11;
  __invariant___031_ __error__099_ Pre l_11;
  Ortac_runtime.Errors.report __error__099_;
  (let c_9 =
     try append_after l_11 i_11 v_3
     with
     | Stack_overflow | Out_of_memory as e ->
         ((__invariant___080_ __error__099_ XPost l_11;
           __invariant___077_ __error__099_ XPost l_11;
           __invariant___072_ __error__099_ XPost l_11;
           __invariant___067_ __error__099_ XPost l_11;
           __invariant___064_ __error__099_ XPost l_11;
           __invariant___059_ __error__099_ XPost l_11;
           __invariant___056_ __error__099_ XPost l_11;
           __invariant___047_ __error__099_ XPost l_11;
           __invariant___042_ __error__099_ XPost l_11;
           __invariant___037_ __error__099_ XPost l_11;
           __invariant___034_ __error__099_ XPost l_11;
           __invariant___031_ __error__099_ XPost l_11;
           Ortac_runtime.Errors.report __error__099_);
          raise e)
     | e ->
         ((Ortac_runtime.Unexpected_exception { allowed_exn = []; exn = e })
            |> (Ortac_runtime.Errors.register __error__099_);
          (__invariant___080_ __error__099_ XPost l_11;
           __invariant___077_ __error__099_ XPost l_11;
           __invariant___072_ __error__099_ XPost l_11;
           __invariant___067_ __error__099_ XPost l_11;
           __invariant___064_ __error__099_ XPost l_11;
           __invariant___059_ __error__099_ XPost l_11;
           __invariant___056_ __error__099_ XPost l_11;
           __invariant___047_ __error__099_ XPost l_11;
           __invariant___042_ __error__099_ XPost l_11;
           __invariant___037_ __error__099_ XPost l_11;
           __invariant___034_ __error__099_ XPost l_11;
           __invariant___031_ __error__099_ XPost l_11;
           Ortac_runtime.Errors.report __error__099_);
          raise e) in
   if
     not
       (try __logical_mem__087_ l_11 c_9
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                {
                  term = "(mem \nl_11:'a l c_9:int):prop";
                  term_kind = Post;
                  exn = e
                })
               |> (Ortac_runtime.Errors.register __error__099_);
             true))
   then
     (Ortac_runtime.Violated_invariant
        { term = "(mem \nl_11:'a l c_9:int):prop"; position = Post })
       |> (Ortac_runtime.Errors.register __error__099_);
   if
     not
       (try
          (Ortac_runtime.Array.get (l_11.t).prev (Ortac_runtime.Z.of_int c_9))
            = i_11
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                { term = " (l.last) -> c ="; term_kind = Post; exn = e })
               |> (Ortac_runtime.Errors.register __error__099_);
             true))
   then
     (Ortac_runtime.Violated_invariant
        { term = " (l.last) -> c ="; position = Post })
       |> (Ortac_runtime.Errors.register __error__099_);
   __invariant___080_ __error__099_ Post l_11;
   __invariant___077_ __error__099_ Post l_11;
   __invariant___072_ __error__099_ Post l_11;
   __invariant___067_ __error__099_ Post l_11;
   __invariant___064_ __error__099_ Post l_11;
   __invariant___059_ __error__099_ Post l_11;
   __invariant___056_ __error__099_ Post l_11;
   __invariant___047_ __error__099_ Post l_11;
   __invariant___042_ __error__099_ Post l_11;
   __invariant___037_ __error__099_ Post l_11;
   __invariant___034_ __error__099_ Post l_11;
   __invariant___031_ __error__099_ Post l_11;
   Ortac_runtime.Errors.report __error__099_;
   c_9)
let remove l_12 c_10 =
  let __error__100_ =
    Ortac_runtime.Errors.create
      {
        Ortac_runtime.start =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 143;
            pos_bol = 5173;
            pos_cnum = 5173
          };
        Ortac_runtime.stop =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 151;
            pos_bol = 5489;
            pos_cnum = 5491
          }
      } "remove" in
  if
    not
      (try __logical_mem__087_ l_12 c_10
       with
       | e ->
           ((Ortac_runtime.Specification_failure
               { term = " = old "; term_kind = Pre; exn = e })
              |> (Ortac_runtime.Errors.register __error__100_);
            true))
  then
    (Ortac_runtime.Violated_invariant { term = " = old "; position = Pre })
      |> (Ortac_runtime.Errors.register __error__100_);
  __invariant___080_ __error__100_ Pre l_12;
  __invariant___077_ __error__100_ Pre l_12;
  __invariant___072_ __error__100_ Pre l_12;
  __invariant___067_ __error__100_ Pre l_12;
  __invariant___064_ __error__100_ Pre l_12;
  __invariant___059_ __error__100_ Pre l_12;
  __invariant___056_ __error__100_ Pre l_12;
  __invariant___047_ __error__100_ Pre l_12;
  __invariant___042_ __error__100_ Pre l_12;
  __invariant___037_ __error__100_ Pre l_12;
  __invariant___034_ __error__100_ Pre l_12;
  __invariant___031_ __error__100_ Pre l_12;
  Ortac_runtime.Errors.report __error__100_;
  (let () =
     try remove l_12 c_10
     with
     | Stack_overflow | Out_of_memory as e ->
         ((__invariant___080_ __error__100_ XPost l_12;
           __invariant___077_ __error__100_ XPost l_12;
           __invariant___072_ __error__100_ XPost l_12;
           __invariant___067_ __error__100_ XPost l_12;
           __invariant___064_ __error__100_ XPost l_12;
           __invariant___059_ __error__100_ XPost l_12;
           __invariant___056_ __error__100_ XPost l_12;
           __invariant___047_ __error__100_ XPost l_12;
           __invariant___042_ __error__100_ XPost l_12;
           __invariant___037_ __error__100_ XPost l_12;
           __invariant___034_ __error__100_ XPost l_12;
           __invariant___031_ __error__100_ XPost l_12;
           Ortac_runtime.Errors.report __error__100_);
          raise e)
     | e ->
         ((Ortac_runtime.Unexpected_exception { allowed_exn = []; exn = e })
            |> (Ortac_runtime.Errors.register __error__100_);
          (__invariant___080_ __error__100_ XPost l_12;
           __invariant___077_ __error__100_ XPost l_12;
           __invariant___072_ __error__100_ XPost l_12;
           __invariant___067_ __error__100_ XPost l_12;
           __invariant___064_ __error__100_ XPost l_12;
           __invariant___059_ __error__100_ XPost l_12;
           __invariant___056_ __error__100_ XPost l_12;
           __invariant___047_ __error__100_ XPost l_12;
           __invariant___042_ __error__100_ XPost l_12;
           __invariant___037_ __error__100_ XPost l_12;
           __invariant___034_ __error__100_ XPost l_12;
           __invariant___031_ __error__100_ XPost l_12;
           Ortac_runtime.Errors.report __error__100_);
          raise e) in
   if
     not
       (try not (__logical_mem__087_ l_12 c_10)
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                {
                  term = "not (mem \nl_12:'a l c_10:int):prop";
                  term_kind = Post;
                  exn = e
                })
               |> (Ortac_runtime.Errors.register __error__100_);
             true))
   then
     (Ortac_runtime.Violated_invariant
        { term = "not (mem \nl_12:'a l c_10:int):prop"; position = Post })
       |> (Ortac_runtime.Errors.register __error__100_);
   __invariant___080_ __error__100_ Post l_12;
   __invariant___077_ __error__100_ Post l_12;
   __invariant___072_ __error__100_ Post l_12;
   __invariant___067_ __error__100_ Post l_12;
   __invariant___064_ __error__100_ Post l_12;
   __invariant___059_ __error__100_ Post l_12;
   __invariant___056_ __error__100_ Post l_12;
   __invariant___047_ __error__100_ Post l_12;
   __invariant___042_ __error__100_ Post l_12;
   __invariant___037_ __error__100_ Post l_12;
   __invariant___034_ __error__100_ Post l_12;
   __invariant___031_ __error__100_ Post l_12;
   Ortac_runtime.Errors.report __error__100_;
   ())
let clear l_13 =
  let __error__101_ =
    Ortac_runtime.Errors.create
      {
        Ortac_runtime.start =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 153;
            pos_bol = 5493;
            pos_cnum = 5493
          };
        Ortac_runtime.stop =
          {
            pos_fname = "src/dllist.mli";
            pos_lnum = 156;
            pos_bol = 5627;
            pos_cnum = 5652
          }
      } "clear" in
  __invariant___080_ __error__101_ Pre l_13;
  __invariant___077_ __error__101_ Pre l_13;
  __invariant___072_ __error__101_ Pre l_13;
  __invariant___067_ __error__101_ Pre l_13;
  __invariant___064_ __error__101_ Pre l_13;
  __invariant___059_ __error__101_ Pre l_13;
  __invariant___056_ __error__101_ Pre l_13;
  __invariant___047_ __error__101_ Pre l_13;
  __invariant___042_ __error__101_ Pre l_13;
  __invariant___037_ __error__101_ Pre l_13;
  __invariant___034_ __error__101_ Pre l_13;
  __invariant___031_ __error__101_ Pre l_13;
  Ortac_runtime.Errors.report __error__101_;
  (let () =
     try clear l_13
     with
     | Stack_overflow | Out_of_memory as e ->
         ((__invariant___080_ __error__101_ XPost l_13;
           __invariant___077_ __error__101_ XPost l_13;
           __invariant___072_ __error__101_ XPost l_13;
           __invariant___067_ __error__101_ XPost l_13;
           __invariant___064_ __error__101_ XPost l_13;
           __invariant___059_ __error__101_ XPost l_13;
           __invariant___056_ __error__101_ XPost l_13;
           __invariant___047_ __error__101_ XPost l_13;
           __invariant___042_ __error__101_ XPost l_13;
           __invariant___037_ __error__101_ XPost l_13;
           __invariant___034_ __error__101_ XPost l_13;
           __invariant___031_ __error__101_ XPost l_13;
           Ortac_runtime.Errors.report __error__101_);
          raise e)
     | e ->
         ((Ortac_runtime.Unexpected_exception { allowed_exn = []; exn = e })
            |> (Ortac_runtime.Errors.register __error__101_);
          (__invariant___080_ __error__101_ XPost l_13;
           __invariant___077_ __error__101_ XPost l_13;
           __invariant___072_ __error__101_ XPost l_13;
           __invariant___067_ __error__101_ XPost l_13;
           __invariant___064_ __error__101_ XPost l_13;
           __invariant___059_ __error__101_ XPost l_13;
           __invariant___056_ __error__101_ XPost l_13;
           __invariant___047_ __error__101_ XPost l_13;
           __invariant___042_ __error__101_ XPost l_13;
           __invariant___037_ __error__101_ XPost l_13;
           __invariant___034_ __error__101_ XPost l_13;
           __invariant___031_ __error__101_ XPost l_13;
           Ortac_runtime.Errors.report __error__101_);
          raise e) in
   if
     not
       (try (is_empty l_13) = true
        with
        | e ->
            ((Ortac_runtime.Specification_failure
                {
                  term = "((is_empty \nl_13:'a l):bool = (True ):bool):prop";
                  term_kind = Post;
                  exn = e
                })
               |> (Ortac_runtime.Errors.register __error__101_);
             true))
   then
     (Ortac_runtime.Violated_invariant
        {
          term = "((is_empty \nl_13:'a l):bool = (True ):bool):prop";
          position = Post
        })
       |> (Ortac_runtime.Errors.register __error__101_);
   __invariant___080_ __error__101_ Post l_13;
   __invariant___077_ __error__101_ Post l_13;
   __invariant___072_ __error__101_ Post l_13;
   __invariant___067_ __error__101_ Post l_13;
   __invariant___064_ __error__101_ Post l_13;
   __invariant___059_ __error__101_ Post l_13;
   __invariant___056_ __error__101_ Post l_13;
   __invariant___047_ __error__101_ Post l_13;
   __invariant___042_ __error__101_ Post l_13;
   __invariant___037_ __error__101_ Post l_13;
   __invariant___034_ __error__101_ Post l_13;
   __invariant___031_ __error__101_ Post l_13;
   Ortac_runtime.Errors.report __error__101_;
   ())
