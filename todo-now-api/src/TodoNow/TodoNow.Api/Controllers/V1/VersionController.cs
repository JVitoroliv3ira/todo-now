using Microsoft.AspNetCore.Mvc;

namespace TodoNow.Api.Controllers.V1;

[Route("")]
[ApiController]
public class VersionController : ControllerBase
{
    [HttpGet]
    public ActionResult<dynamic> Version()
    {
        return Ok(new
        {
            Version = "Em desenvolvimento"
        });
    }
}