module Critter4Us.TagDb
  ( empty
  , addTag
  , tagsFor
  , idsFor
  , TagDb
  , Tags
  , Ids
  ) where

import Prelude
import Critter4UsRefactored.Animal as Animal
import Data.Map as Map
import Data.Map (Map)
import Data.Lens (Lens', lens, over, view)
import Data.Lens.At (at)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Unfoldable (class Unfoldable, singleton)

type Tags = Array String
type Ids = Array Animal.Id

type TagDb =
  { tagsById ∷ Map Animal.Id Tags
  , idsByTag ∷ Map String Ids
  }

empty ∷ TagDb
empty =
  { tagsById: Map.empty
  , idsByTag: Map.empty
  }

addTag ∷ Animal.Id → String → TagDb → TagDb
addTag id tag db =
  db
    # addTagTo id tag
    # addIdTo tag id

tagsFor ∷ Animal.Id → TagDb → Tags
tagsFor id tagDb = view (_idTags id) tagDb # fromMaybe []

idsFor ∷ String → TagDb → Ids
idsFor name tagDb = view (_tagIds name) tagDb # fromMaybe []

--- Helpers

addTagTo ∷ Animal.Id → String → TagDb → TagDb
addTagTo id tag = over (_idTags id) $ appendOrCreate tag

addIdTo ∷ String → Animal.Id → TagDb → TagDb
addIdTo tag id = over (_tagIds tag) $ appendOrCreate id

-- I can't find a Lens function that does this for me.
appendOrCreate ∷ ∀ a f. Monoid (f a) ⇒ Unfoldable f ⇒ a → Maybe (f a) → Maybe (f a)
appendOrCreate new = fromMaybe mempty >>> (_ <> singleton new) >>> Just

-- Lenses

_tagsById ∷ Lens' TagDb (Map Animal.Id Tags)
_tagsById = lens _.tagsById $ _ { tagsById = _ }

_idsByTag ∷ Lens' TagDb (Map String Ids)
_idsByTag = lens _.idsByTag $ _ { idsByTag = _ }

_idTags ∷ Animal.Id → Lens' TagDb (Maybe (Array String))
_idTags id = _tagsById <<< at id

_tagIds ∷ String → Lens' TagDb (Maybe (Array Animal.Id))
_tagIds tag = _idsByTag <<< at tag
