module Index where

{- Paste the following into the repl

import Index

import Data.Maybe
import Data.Lens
import Data.Map as Map
import Data.Lens.At (at)
import Data.Lens.Index (ix)
import Data.String as String

-}

import Prelude
import Data.Maybe (Maybe)
import Data.Lens (Lens', Traversal', _1, traversed)
import Data.Lens.At (class At, at)
import Data.Lens.Index (class Index, ix)
import Data.Traversable (class Traversable)
import Data.Tuple (Tuple)

_at1 ∷ ∀ s a. At s Int a ⇒ Lens' s (Maybe a)
_at1 = at 1

_ix1 ∷ ∀ s a. Index s Int a ⇒ Traversal' s a
_ix1 = ix 1

{- Composition -}

_trav_ix1 ∷ ∀ trav indexed a. Traversable trav ⇒ Index indexed Int a ⇒ Traversal' (trav indexed) a
_trav_ix1 = traversed <<< ix 1

_ix1_trav ∷ ∀ indexed trav a. Index indexed Int (trav a) ⇒ Traversable trav ⇒ Traversal' indexed a
_ix1_trav = ix 1 <<< traversed

_at1_ix1 ∷ ∀ keyed indexed a. At keyed Int indexed ⇒ Index indexed Int a ⇒ Traversal' keyed a
_at1_ix1 = at 1 <<< traversed <<< ix 1

{- Composition exercise -}

_1_ix1 ∷ ∀ indexed a _1_. Index indexed Int a ⇒ Traversal' (Tuple indexed _1_) a
_1_ix1 = _1 <<< ix 1

_ix1_1 ∷ ∀ indexed a _1_. Index indexed Int (Tuple a _1_) ⇒ Traversal' indexed a
_ix1_1 = ix 1 <<< _1

_ix1_at1 ∷ ∀ indexed keyed a. Index indexed Int keyed ⇒ At keyed Int a ⇒ Traversal' indexed (Maybe a)
_ix1_at1 = ix 1 <<< at 1

_ix1_ix1 ∷ ∀ indexed1 indexed2 a. Index indexed1 Int indexed2 ⇒ Index indexed2 Int a ⇒ Traversal' indexed1 a
_ix1_ix1 = ix 1 <<< ix 1
