module Paths_Second (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [1,1] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\Visvaldas\\AppData\\Roaming\\cabal\\bin"
libdir     = "C:\\Users\\Visvaldas\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-7.10.2\\Second-1.1-DQjT6Ge2RhkI0h1QrvLYpk"
datadir    = "C:\\Users\\Visvaldas\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-7.10.2\\Second-1.1"
libexecdir = "C:\\Users\\Visvaldas\\AppData\\Roaming\\cabal\\Second-1.1-DQjT6Ge2RhkI0h1QrvLYpk"
sysconfdir = "C:\\Users\\Visvaldas\\AppData\\Roaming\\cabal\\etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Second_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Second_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "Second_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Second_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Second_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
