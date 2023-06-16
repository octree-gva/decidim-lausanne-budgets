<h1 align="center">
    <img
        src="https://github.com/octree-gva/meta/blob/main/decidim/static/header.png?raw=true"
        alt="Decidim - Octree Participatory democracy on a robust and open source solution" />
</h1>
<h4 align="center">
    <a href="https://www.octree.ch">Octree</a> |
    <a href="https://octree.ch/en/contact-us/">Contact Us</a> |
    <a href="https://blog.octree.ch">Our Blog (FR)</a><br/><br/>
    <a href="https://decidim.org">Decidim</a> |
    <a href="https://docs.decidim.org/en/">Decidim Docs</a> |
    <a href="https://meta.decidim.org">Participatory Governance (META DECIDIM)</a><br/><br/>
    <a href="https://matrix.to/#/+decidim:matrix.org">Decidim Community (Matrix+Element.io)</a>
</h4>
<p align="center">
    <a href="https://participer.lausanne.ch">
        <img
            src="https://github.com/octree-gva/meta/blob/main/decidim/static/participer_lausanne/chip.png?raw=true"
            alt="Lausanne Participe — Une plateforme de participation pour imaginer et réaliser ensemble" />
    </a>
</p>

# Public Participatory Budgeting

This repository create a new participatory component, cloned from participatory budgets. It is done on decidim version 0.24.3 exclusively for now.

## Usage

* As a non-connected user, I can insert my personal data, and use it to vote. This data will be checked oveer the official residentship database.
* As a non-connected user, I have a clear view on the vote process. First insert my personal data, then vote, then finalize my vote.

## Restrictions
From the original budget component, the following features are not implemented: 

1. Authorizations: You can not define authorizations for this component (as it authorized only registered user)
2. Percentage rules: we improve the flow for `minimu_project` vote flow only. The others rules are un-tested and highly volatile

## Warning
This repository was done for the very specific use case of Lausanne City, you probably won't find any usage of this module. 

## Why
The data-protection law in Switzerland is clear: save the minimal data for a limited amount of time. 

As at Lausanne we see PB have somehow lower participation rates, we decide to experiment around public access. We go through a another strategy than Authorization in order to: 

- Keep the submissions in the context of a PB
- Be able to remove user data without affecting behaviour
- Having a nicer UX flow as we now know there is a first step process in PB. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-lausanne-budgets", git: "https://github.com/octree-gva/decidim-lausanne-budgets"
```

Then execute:

```bash
bundle
bundle exec rails decidim_lausanne_budgets:install:migrations
bundle exec rails db:migrate
```

## Testing

The [Rakefile](Rakefile) is shipped with a
`test_app` using `docker-compose` to run a database.
If you haven't done it already, [install](https://docs.docker.com/get-docker/) docker](https://docs.docker.com/get-docker/).

```bash
    bundle exec rake test_app
```
## Local development

Run a postgres database
```
docker-compose up -d
cp .env.sample .env.local && source .env.local
```
If you haven't done it already, [install](https://docs.docker.com/get-docker/) docker](https://docs.docker.com/get-docker/).

Run if you haven't already:
```bash
bundle
```

And then
```bash
bundle exec rake development_app
```

```bash
    bundle exec rake development_app
```

## Contributing

This repository is not yet ready for contributions.

## License

This engine is distributed under the [GNU AFFERO GENERAL PUBLIC LICENSE](LICENSE.md).

<br /><br />

<p align="center">
    <img src="https://raw.githubusercontent.com/octree-gva/meta/main/decidim/static/octree_and_decidim.png" height="90" alt="Decidim Installation by Octree" />
</p>
