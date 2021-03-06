(** Commutation of path groupoid with polynomials *)
Require Import UniMath.Foundations.All.
Require Import UniMath.MoreFoundations.All.

Require Import UniMath.CategoryTheory.Core.Categories.
Require Import UniMath.CategoryTheory.Core.Functors.
Require Import UniMath.CategoryTheory.Core.NaturalTransformations.
Require Import UniMath.CategoryTheory.Core.Isos.
Require Import UniMath.CategoryTheory.Groupoids.

Require Import UniMath.Bicategories.Core.Bicat.
Import Bicat.Notations.
Require Import UniMath.Bicategories.PseudoFunctors.Display.Base.
Require Import UniMath.Bicategories.PseudoFunctors.Display.Map1Cells.
Require Import UniMath.Bicategories.PseudoFunctors.Display.Map2Cells.
Require Import UniMath.Bicategories.PseudoFunctors.Display.Identitor.
Require Import UniMath.Bicategories.PseudoFunctors.Display.Compositor.
Require Import UniMath.Bicategories.PseudoFunctors.Display.PseudoFunctorBicat.
Require Import UniMath.Bicategories.PseudoFunctors.PseudoFunctor.
Import PseudoFunctor.Notations.
Require Import UniMath.Bicategories.PseudoFunctors.Examples.Identity.
Require Import UniMath.Bicategories.PseudoFunctors.Examples.Composition.
Require Import UniMath.Bicategories.Transformations.PseudoTransformation.
Require Import UniMath.Bicategories.Core.Examples.OneTypes.

Require Import signature.hit_signature.
Require Import prelude.all.
Require Import algebra.one_types_polynomials.
Require Import algebra.groupoid_polynomials.

Require Export hit_biadjunction.path_groupoid_commute.path_groupoid_const_id.
Require Export hit_biadjunction.path_groupoid_commute.path_groupoid_sum.
Require Export hit_biadjunction.path_groupoid_commute.path_groupoid_prod.

Local Open Scope cat.

Opaque comp_psfunctor.

(** Commutation of path groupoid with polynomials *)
Definition poly_path_groupoid
           (P : poly_code)
  : pstrans
      (comp_psfunctor
         (⦃ P ⦄)
         path_groupoid)
      (comp_psfunctor
         path_groupoid
         (⟦ P ⟧)).
Proof.
  induction P as [ A | | P₁ IHP₁ P₂ IHP₂ | P₁ IHP₁ P₂ IHP₂ ].
  - exact (const_path_groupoid A).
  - exact id_path_groupoid.
  - exact (path_groupoid_sum IHP₁ IHP₂).
  - exact (path_groupoid_prod IHP₁ IHP₂).
Defined.
