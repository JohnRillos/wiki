# %wiki

An app for building your own wiki on [Urbit](https://urbit.org).

---

[Proposal](https://urbit.org/grants/wiki) <sup>[(mirror)](./proposal.md)</sup>

[Overview](./src/doc/overview.udon)

[Changelog](./src/doc/changelog.udon)

Documentation and release notes can also be viewed in the [%docs](https://github.com/tinnus-napbus/docs-app) app.


## Installation
```
|install ~holnes %wiki
```

## Project Structure

`src/`: Hoon source code. All code here is original and specific to this project.

`deps/`: Hoon dependencies are pasted into this directory. None of the code here is original to this project.

`desk`: Contains the name of the desk. App will run and be distributed with this desk name.

`_sync.sh`: Continuously syncs project files with a desk in a pier.

`_dist.sh`: Copies project files into your ship's pier.

## Building from source

Unix:
* `./_sync.sh PATH/TO/PIER` to sync `src/` and `deps/` to your dev ship's pier.

Dojo:
* `|commit %wiki` to build your desk
* `|install our %wiki` to install your desk and start the app for the first time

## Distributing the app

* `./_dist.sh PATH/TO/PIER` to copy `src/` and `deps/` to your distribution ship's pier.
* Dojo: `|commit %wiki`
