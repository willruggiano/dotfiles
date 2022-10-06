1. Use keybase to generate a decide key; `keybase pgp gen --multi`
   - Use <user>@<hostname> as name
2. Rekey password store (from a device with unencrypted access to it); `pass init <old-key>... <new-key>`
3. Upstream. The new device should now have unecrypted access to the password-store
