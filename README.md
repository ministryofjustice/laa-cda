# LAA Court Data Adaptor Ruby client

## Usage

Add to `Gemfile`:

```ruby
gem 'laa-cda', git: 'https://github.com/ministryofjustice/laa-cda'
```

## Configuration

```ruby
LAA::Cda.configure do |conf|
  conf.root_url = <URL of Court Data Adaptor>
  conf.oauth2_id = <Oauth 2.0 id>
  conf.oauth2_secret = <Oauth 2.0 secret>
end
```

## Search

To search for prosecution cases:

```ruby
cases = LAA::Cda::ProsecutionCase.search(name:, date_of_birth:)
# => Array of LAA::Cda::ProsecutionCase instances
```

## Classes

### `LAA::Cda::ProsecutionCase`

| Attribute | Notes |
|---|---|
| `case_number` | Prosecution case number. |
| `status` | Status of the case. E.g. `ACTIVE`. |
| `defendants` | List of defendants. An array of `LAA::Cda::Defendant` instances. |
| `hearings` | List of hearings. An array of `LAA::Cda::Hearing` instances. |

### `LAA::Cda::Defendant`

| Attribute | Notes |
|---|---|
| `id` | Unique id of the defendant record linked to the prosecution case. |
| `arrest_summons_number` | Arrest summons number of the defendant. |
| `name` | Full name of the defendant. |
| `date_of_birth` | Date of birth of the defendant. |
| `offences` | List of offences. An array of `LAA::Cda::Offence` instances. |

### `LAA::Cda::Offence`

| Attribute | Notes |
|---|---|
| `title` | Title of the offence. |

### `LAA::Cda::Hearing`

| Attribute | Notes |
|---|---|
| `id` | Unique id of the hearing record linked to the prosecution case. |
| `type` | Type of hearing. E.g. `Trial (TRL)` |
| `court` | The court for the hearing. An instance of `LAA::Cda::Court`. |
| `hearing_days` | List of days for the hearing. An array of `LAA::Cda::HearingDay` instances. |

### `LAA::Cda::Court`

| Attribute | Notes |
|---|---|
| `id` | Unique id of the court record linked to the hearing. |
| `name` | Name of the court. |

### `LAA::Cda::HearingDay`

`LAA::Cda::HearingDay` does not expose any attributes yet.
