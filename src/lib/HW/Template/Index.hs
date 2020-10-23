module HW.Template.Index
  ( indexTemplate
  )
where

import qualified HW.Template.Base
import qualified HW.Template.Newsletter
import qualified HW.Template.Podcast
import qualified HW.Type.BaseUrl as BaseUrl
import qualified HW.Type.Config as Config
import qualified HW.Type.Date as Date
import qualified HW.Type.Episode as Episode
import qualified HW.Type.Issue as Issue
import qualified HW.Type.Number as Number
import qualified HW.Type.Route as Route
import qualified Lucid as Html

indexTemplate
  :: Config.Config
  -> Maybe Issue.Issue
  -> Maybe Episode.Episode
  -> Html.Html ()
indexTemplate config maybeIssue maybeEpisode = do
  let
    baseUrl = Config.baseUrl config
    head_ :: Html.Html ()
    head_ = case Config.googleSiteVerification config of
      Nothing -> mempty
      Just googleSiteVerification ->
        Html.meta_
          [ Html.name_ "google-site-verification"
          , Html.content_ googleSiteVerification
          ]
  HW.Template.Base.baseTemplate baseUrl "Haskell Weekly" head_ $ do
    Html.h2_ [Html.class_ "f2 mv3 tracked-tight"] $ Html.a_
      [ Html.class_ "no-underline purple"
      , Html.href_
        $ Route.toText baseUrl Route.Newsletter
      ]
      "Newsletter"
    Html.p_ [Html.class_ "lh-copy"] $ do
      "The Haskell Weekly Newsletter covers the Haskell programming language. "
      "Each issue features several hand-picked links to interesting content about Haskell from around the web."
    case maybeIssue of
      Nothing -> pure ()
      Just issue -> issueTemplate baseUrl issue
    HW.Template.Newsletter.newsletterActionTemplate baseUrl
    Html.h2_ [Html.class_ "f2 mv3 tracked-tight"] $ Html.a_
      [ Html.class_ "no-underline purple"
      , Html.href_
        $ Route.toText baseUrl Route.Podcast
      ]
      "Podcast"
    Html.p_ [Html.class_ "lh-copy"] $ do
      "The Haskell Weekly Podcast covers the Haskell programming language. "
      "Listen to professional software developers discuss using functional programming to solve real-world business problems. "
      "Each episode uses a conversational two-host format and runs for about 15 minutes."
    case maybeEpisode of
      Nothing -> pure ()
      Just episode -> episodeTemplate baseUrl episode
    HW.Template.Podcast.podcastActionTemplate baseUrl
    Html.h2_ [Html.class_ "f2 mv3 tracked-tight"] "Survey"
    Html.p_ [Html.class_ "lh-copy"] $ do
      "The State of Haskell Survey is a yearly survey of the Haskell community. "
      "The survey is typically open for two weeks at the beginning of November. "
      "You can view the results of previous surveys:"
    Html.ul_ [Html.class_ "lh-copy"] $ do
      Html.li_ $ Html.a_
        [Html.href_ "https://taylor.fausak.me/2019/11/16/haskell-survey-results/"]
        "2019 State of Haskell Survey results"
      Html.li_ $ Html.a_
        [ Html.href_
            "https://taylor.fausak.me/2018/11/18/2018-state-of-haskell-survey-results/"
        ]
        "2018 State of Haskell Survey results"
      Html.li_ $ Html.a_
        [ Html.href_
            "https://taylor.fausak.me/2017/11/15/2017-state-of-haskell-survey-results/"
        ]
        "2017 State of Haskell Survey results"
    Html.h2_ [Html.class_ "f2 mv3 tracked-tight"] "Contributing"
    Html.p_ [Html.class_ "lh-copy"] $ do
      "If you would like to contribute content to Haskell Weekly, please open an issue "
      Html.a_
        [Html.href_ "https://github.com/haskellweekly/haskellweekly"]
        "on GitHub"
      " or send an email to "
      Html.a_ [Html.href_ "mailto:info@haskellweekly.news"] "info@haskellweekly.news"
      "."
    Html.h2_ [Html.class_ "f2 mv3 tracked-tight"] "Advertising"
    Html.p_ [Html.class_ "lh-copy"] $ do
      "If you would like to advertise with Haskell Weekly, please consult our "
      Html.a_
        [ Html.href_ $ Route.toText
            baseUrl
            Route.Advertising
        ]
        "advertising page"
      "."

episodeTemplate
  :: BaseUrl.BaseUrl -> Episode.Episode -> Html.Html ()
episodeTemplate baseUrl episode = Html.p_ $ do
  let number = Episode.number episode
  Html.a_
      [ Html.href_
        . Route.toText baseUrl
        $ Route.Episode number
      ]
    $ do
        "Episode "
        Html.toHtml $ Number.toText number
  " of the podcast was published on "
  Html.toHtml . Date.toShortText $ Episode.date episode
  ". Browse "
  Html.a_
    [ Html.href_
        $ Route.toText baseUrl Route.Podcast
    ]
    "the archives"
  " for older episodes."

issueTemplate :: BaseUrl.BaseUrl -> Issue.Issue -> Html.Html ()
issueTemplate baseUrl issue = Html.p_ $ do
  let number = Issue.issueNumber issue
  Html.a_
      [ Html.href_
        . Route.toText baseUrl
        $ Route.Issue number
      ]
    $ do
        "Issue "
        Html.toHtml $ Number.toText number
  " of the newsletter was published on "
  Html.toHtml . Date.toShortText $ Issue.issueDate issue
  ". Browse "
  Html.a_
    [ Html.href_
        $ Route.toText baseUrl Route.Newsletter
    ]
    "the archives"
  " for older issues."
