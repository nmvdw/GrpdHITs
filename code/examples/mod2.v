(** Here we define the signature for the integers modulo 2 *)
Require Import UniMath.Foundations.All.
Require Import UniMath.MoreFoundations.All.

Require Import UniMath.CategoryTheory.Core.Categories.
Require Import UniMath.Bicategories.Core.Bicat.
Require Import UniMath.Bicategories.Core.Examples.OneTypes.

Require Import prelude.all.
Require Import signature.hit_signature.
Require Import signature.hit.
Require Import algebra.one_types_polynomials.
Require Import algebra.one_types_endpoints.
Require Import algebra.one_types_homotopies.
Require Import displayed_algebras.displayed_algebra.
Require Import displayed_algebras.globe_over_lem.

Local Open Scope cat.

Definition mod2_point_constr
  : poly_code
  := C unit_one_type + I.

Inductive mod2_paths : Type :=
| mod : mod2_paths.

Inductive mod2_homots : Type :=
| ap_mod : mod2_homots.

Definition mod2_signature
  : hit_signature.
Proof.
  simple refine (_ ,, _ ,, _ ,, _ ,, _ ,, _ ,, _ ,, _ ,, _ ,, _  ,, _ ,, _ ,, _ ,, _).
  - exact mod2_point_constr.
  - exact mod2_paths.
  - exact (λ _, I).
  - exact (λ _, comp ((comp (ι₂ _ _) constr))
                     (comp (ι₂ _ _) constr)).
  - exact (λ _, id_e _ _).
  - exact mod2_homots.
  - exact (λ _, I).
  - exact (λ _, C unit_one_type).
  - exact (λ _, @c _ _ unit_one_type tt).
  - exact (λ _, @c _ _ unit_one_type tt).
  - exact (λ _,
           comp
             (comp
                (comp
                   (comp (ι₂ (C unit_one_type) I) constr)
                   (comp (ι₂ (C unit_one_type) I) constr))
                (ι₂ (C unit_one_type) I))
             constr).
  - exact (λ _, comp (ι₂ (C unit_one_type) I) constr).
  - intro j.
    apply ap_constr.
    refine (trans_e
              (inv_e (comp_id_l _))
              _).
    refine (trans_e
              (comp_assoc _ _ _)
              _).
    refine (trans_e
              (path_inr
                 (C unit_one_type)
                 (path_constr
                    mod
                    (id_e _ _)))
              _).
    refine (trans_e
              (inv_e (comp_assoc _ _ _))
              _).
    refine (trans_e
              (comp_id_l _)
              _).
    apply comp_id_l.
  - intro j.
    simpl.
    refine (trans_e
              (inv_e (comp_assoc _ _ _))
              _).
    refine (trans_e
              (inv_e (comp_assoc _ _ _))
              _).
    refine (trans_e
              (path_constr mod (comp (ι₂ _ _) constr)
              )
              _).
    apply comp_id_r.
Defined.

Section Mod2AlgebraProjections.
  Variable (X : hit_algebra_one_types mod2_signature).

  Definition mod2_carrier
    : one_type
    := pr111 X.

  Definition mod2_Z
    : mod2_carrier
    := pr211 X (inl tt).

  Definition mod2_S
    : mod2_carrier → mod2_carrier
    := λ x, pr211 X (inr x).

  Definition mod2_mod
    : ∏ (x : mod2_carrier), mod2_S (mod2_S x) = x
    := pr21 X mod.

  Definition mod2_ap_mod
    : ∏ (n : mod2_carrier),
      maponpaths mod2_S (mod2_mod n)
      =
      mod2_mod (mod2_S n)
    := λ n,
       !(maponpathscomp inr (pr211 X) (mod2_mod n))
       @ maponpaths
           (maponpaths (pr211 X))
           (!(pathscomp0rid _))
       @ pr2 X ap_mod n (idpath _)
       @ pathscomp0rid _.
End Mod2AlgebraProjections.

Section Mod2Induction.
  Context {X : hit_algebra_one_types mod2_signature}
          (Y : alg_carrier X → one_type)
          (YZ : Y (mod2_Z X))
          (YS : ∏ (n : alg_carrier X), Y n → Y (mod2_S X n))
          (Ymod : ∏ (n : alg_carrier X) (y : Y n),
                  @PathOver _ _ _ Y (YS _ (YS n y)) y (mod2_mod X n))
          (Yap_mod : ∏ (n : alg_carrier X)
                       (nn : Y n),
                     globe_over
                       Y
                       (mod2_ap_mod X n)
                       (@apd_2 _ _ _ Y (mod2_S X) YS _ _ (mod2_mod X n) _ _ (Ymod n nn))
                       (Ymod (mod2_S X n) (YS n nn))).

  Local Definition cY
    : ∏ (x : poly_act (point_constr mod2_signature) (alg_carrier X)),
      poly_dact (point_constr mod2_signature) Y x → Y (alg_constr X x).
  Proof.
    intros x xx.
    induction x as [ | x].
    - induction a.
      exact YZ.
    - exact (YS x xx).
  Defined.
  
  Definition help_globe_type
             {n : alg_carrier X}
             (nn : Y n)
             {p : tt = tt}
             (pp : @PathOver unit tt tt (λ _ : unit, unit) tt tt p)
    : UU.
  Proof.
    refine
      (globe_over
         Y
         (pr2 X ap_mod n p)
         (@apd_2
            _ _
            (poly_dact (point_constr mod2_signature) Y)
            Y
            _ cY
            _ _
            _
            _ _
            (composePathOver
               (inversePathOver
                  (identityPathOver _))
               (composePathOver
                  (identityPathOver _)
                  (composePathOver
                     (@PathOver_inr
                        (C unit_one_type) I (pr111 X) Y
                        ((pr211 X) (inr ((pr211 X) (inr n)))) n ((pr21 X) mod n)
                        (YS ((pr211 X) (inr n)) (YS n nn)) nn (Ymod n nn))
                     (composePathOver
                        (inversePathOver _)
                        (composePathOver
                           (identityPathOver _)
                           (identityPathOver _)))))))
         (composePathOver
            (inversePathOver
               (identityPathOver _))
            (composePathOver
               (identityPathOver _)
               (composePathOver
                  (Ymod ((pr211 X) (inr n)) (cY (inr n) nn))
                  (composePathOver
                     (inversePathOver
                        (identityPathOver _))
                     (composePathOver
                        (identityPathOver _)
                        (identityPathOver _))))))).
    apply idpath.
  Defined.

  Definition help_globe
             {n : alg_carrier X}
             (nn : Y n)
             {p : tt = tt}
             (pp : @PathOver unit tt tt (λ _ : unit, unit) tt tt p)
    : help_globe_type nn pp.
  Proof.
    unfold help_globe_type.
    refine
      (globe_over_move_globe_one_type
         (one_type_isofhlevel (pr111 X))
         (concat_globe_over
            (@apd2_globe_over
               _ _
               (poly_dact (point_constr mod2_signature) Y)
               Y
               _ cY
               _ _ _ _ _ _ _ _ _
               _)
            _)).
    - refine (concat_globe_over
                (globe_over_compose_left'
                   _
                   (globe_over_compose_left'
                      _
                      (globe_over_compose_left'
                         _
                         (globe_over_compose_left'
                            _
                            (globe_over_id_right _)))))
                _).
      refine (concat_globe_over
                (globe_over_compose_left'
                   _
                   (globe_over_compose_left'
                      _
                      (globe_over_compose_left'
                         _
                         (globe_over_id_right _))))
                _).
      refine (concat_globe_over
                (globe_over_compose_left'
                   _
                   (globe_over_compose_left'
                      _
                      (globe_over_id_right _)))
                _).
      refine (concat_globe_over
                (globe_over_compose_left'
                   _
                   (globe_over_id_left _))
                _).
      apply globe_over_id_left.
    - refine (inv_globe_over _).
      refine (concat_globe_over _ _).
      + refine (concat_globe_over
                  (globe_over_compose_left'
                     _
                     (globe_over_compose_left'
                        _
                        (globe_over_compose_left'
                           _
                           (globe_over_compose_left'
                              _
                              (globe_over_id_right _)))))
                  _).
        refine (concat_globe_over
                  (globe_over_compose_left'
                     _
                     (globe_over_compose_left'
                        _
                        (globe_over_compose_left'
                           _
                           (globe_over_id_right _))))
                  _).
        refine (concat_globe_over
                  (globe_over_compose_left'
                     _
                     (globe_over_compose_left'
                        _
                        (globe_over_id_right _)))
                  _).
        refine (concat_globe_over
                  (globe_over_compose_left'
                     _
                     (globe_over_id_left _))
                  _).
        apply globe_over_id_left.
      + simpl.
        refine (inv_globe_over _).        
        refine (concat_globe_over
                  _
                  (Yap_mod n nn)).
        refine (concat_globe_over
                  (@apd2_globe_over
                     _ _
                     (poly_dact (point_constr mod2_signature) Y)
                     Y
                     _ cY
                     _ _ _ _ _ _ _ _ _
                     (inv_globe_over
                        (@apd2_inr
                           (C unit_one_type) I
                           _ _ _ _ _ _ _
                           (Ymod n nn))))
                  _).
        exact (apd2_comp _ _ _).
  Qed.

  Definition make_mod2_disp_algebra
    : disp_algebra X.
  Proof.
    use make_disp_algebra.
    - exact Y.
    - exact cY.
    - intros j x y.
      induction j.
      exact (Ymod x y).
    - intros j n nn p pp.
      induction j.
      exact (help_globe nn pp).
  Defined.

  Variable (HX : is_HIT mod2_signature X).

  (** Induction principle *)
  Definition mod2_ind_disp_algebra_map
    : disp_algebra_map make_mod2_disp_algebra
    := HX make_mod2_disp_algebra.

  Definition mod2_ind
    : ∏ (x : alg_carrier X), Y x
    := pr1 mod2_ind_disp_algebra_map.

  Definition mod2_ind_Z
    : mod2_ind (mod2_Z X) = YZ
    := pr12 mod2_ind_disp_algebra_map (inl tt).

  Definition mod2_ind_S
             (n : alg_carrier X)
    : mod2_ind (mod2_S X n) = YS n (mod2_ind n)
    := pr12 mod2_ind_disp_algebra_map (inr n).
  
  Definition mod2_ind_mod
             (n : alg_carrier X)
    : PathOver_square
        _
        (idpath _)
        (apd (pr1 mod2_ind_disp_algebra_map) (alg_path X mod n))
        (Ymod n (pr1 mod2_ind_disp_algebra_map n))
        (pr12 mod2_ind_disp_algebra_map
              (inr ((pr211 X) (inr n)))
         @ maponpaths
             (λ x : Y ((pr211 X) (inr n)), YS ((pr211 X) (inr n)) x)
             ((pr12 mod2_ind_disp_algebra_map) (inr n)))
        (idpath (pr1 mod2_ind_disp_algebra_map n)).
  Proof.
    pose (pr22 mod2_ind_disp_algebra_map mod n) as p.
    simpl in p.
    cbn in p.
    rewrite !pathscomp0rid in p.
    exact p.
  Qed.
End Mod2Induction.
