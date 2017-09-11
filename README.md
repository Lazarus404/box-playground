# Box Playground

Throwaway playground Elixir app targeting the Box.com API 2.0.  Wanted to experiment with timings.  This app gets past the necessaries for authentication, so it might be useful for someone.

## Configuration

To use, follow the steps for creating an app on Box.com.  You'll then need to create a PEM cert and an associated JSON file. It's easier to let Box do this for you, as it will also generate the JSON file which you can download.  Once you have that JSON file, pop it in `<app_folder>/priv` and update the config file with the correct path.  The app will use this directly.

## Usage

This isn't a library (someone else will need to foot the legwork for that).  It's just a starting point (a playground).  So, to use, simply run `iex -S mix` from the root of the app.  From there, you can get a service level token with:

```
Box.Service.get_service_token()
```

Or a user token with:

```
Box.Service.get_user_token(user_id)
```

To get a user token, you'll need to create a user.  You can do that with:

```
Box.Service.create_user(name)
```

The `name` parameter can be any binary string you like

## Want More?

Please let me know if there's an interest in an actual library and I'll consider doing that.