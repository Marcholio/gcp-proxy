import { Request, Response } from "express";
import { request } from "undici";

// Add a list of whitelisted hosts or keep as is to allow all http requests
// const whitelistedHosts = ["https://api.github.com", "https://google.com"];
const whitelistedHosts = ["http"];

export const handler = async (req: Request, res: Response) => {
  const { url, method, headers, body } = req.body;

  if (url && method && headers) {
    const urlOk = whitelistedHosts.find((host) => url.startsWith(host));

    if (urlOk) {
      const response = await request(url, {
        method,
        headers,
        body: body && body !== {} ? JSON.stringify(body) : undefined,
      });

      const resText = await response.body.text();
      res.status(response.statusCode).send(resText);
      return;
    }
  }

  res.status(400).send();
};
