module Main where

import Data.Maybe (fromMaybe)
import Hakyll
import Text.Pandoc.Highlighting (Style, zenburn, styleToCss)
import Text.Pandoc.Options (WriterOptions (..))

main :: IO ()
main = hakyll $ do
  -- Load all templates.
  match "templates/*" $ compile templateCompiler

  -- Load all assets.
  match "assets/*" $ do
    route   idRoute
    compile copyFileCompiler

  -- Create a stylesheet for syntax highlighting.
  create ["css/syntax.css"] $ do
    route idRoute
    compile $ do
      makeItem $ styleToCss pandocCodeStyle

  -- Load compiled tailwind css file.
  match "css/__global.css" $ do
    route idRoute
    compile compressCssCompiler

  -- Load all book pages.
  match "src/*" $ do
    route $ setExtension "html"
    compile $
      pandocCompiler'
        >>= loadAndApplyTemplate "templates/page.html" pageTitleContext

  -- Create the home page.
  create ["index.html"] $ do
    route idRoute
    compile $ do
      pages <- loadAll "src/*" :: Compiler [Item String]
      getResourceBody
        >>= applyAsTemplate (mkPagesContext pages <> defaultContext)
        >>= relativizeUrls

pageTitleContext :: Context String
pageTitleContext = field "title" (getResourceMetadata . itemIdentifier)
                   <> defaultContext

-- | Build a `Context` for the list of all pages
mkPagesContext :: [Item String] -> Context a
mkPagesContext = listField "pages" pageContext . pure

-- | `Context` for linking a page
pageContext :: Context a
pageContext =
  field "title" (getResourceMetadata . itemIdentifier) <>
  field "url" (fmap (fromMaybe "No Route") . getRoute . itemIdentifier)

getResourceMetadata :: MonadMetadata m => Identifier -> m String
getResourceMetadata iden =
  fromMaybe "No title" . lookupString "title" <$> getMetadata iden

pandocCodeStyle :: Style
pandocCodeStyle = zenburn

pandocCompiler' :: Compiler (Item String)
pandocCompiler' =
  pandocCompilerWith
    defaultHakyllReaderOptions
    defaultHakyllWriterOptions
      { writerHighlightStyle = Just pandocCodeStyle
      }
