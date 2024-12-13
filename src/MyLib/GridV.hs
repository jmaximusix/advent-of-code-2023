module MyLib.GridV (Direction, GridMap, VecPos, asGridMap, directDirs, gridElementsSame, neighbors, turn90L) where

import Control.Applicative (liftA2)
import Data.Function (on)
import qualified Data.Map as Map
import Linear (V2 (V2), (!*))
import MyLib.Geometry (Grid, dimensions)

type Direction = V2 Int

data DirectionOct = N | NE | E | SE | S | SW | W | NW deriving (Show, Ord, Eq, Read)

dir :: DirectionOct -> Direction
dir enumval = case enumval of
  N -> V2 0 (-1)
  NE -> V2 1 (-1)
  E -> V2 1 0
  SE -> V2 1 1
  S -> V2 0 1
  SW -> V2 (-1) 1
  W -> V2 (-1) 0
  NW -> V2 (-1) (-1)

type VecPos = V2 Int

type GridMap a = Map.Map VecPos a

turn90L :: Direction -> Direction
turn90L = (V2 (dir S) (dir W) !*)

turn90R :: Direction -> Direction
turn90R = (V2 (dir N) (dir E) !*)

asGridMap :: Grid a -> GridMap a
asGridMap = Map.fromList . liftA2 zip vecPoints concat

directDirs :: [Direction]
directDirs = map dir [N, E, S, W]

octDirs :: [Direction]
octDirs = map dir [N, NE, E, SE, S, SW, W, NW]

neighbors :: VecPos -> [VecPos]
neighbors = flip map directDirs . (+)

neighborsOct :: VecPos -> [VecPos]
neighborsOct = flip map octDirs . (+)

vecPoints :: Grid a -> [VecPos]
vecPoints g = let (xdim, ydim) = dimensions g in [V2 x y | y <- [0 .. ydim - 1], x <- [0 .. xdim - 1]]

gridElementsSame :: (Eq a) => GridMap a -> VecPos -> VecPos -> Bool
gridElementsSame grid = (==) `on` (`Map.lookup` grid)