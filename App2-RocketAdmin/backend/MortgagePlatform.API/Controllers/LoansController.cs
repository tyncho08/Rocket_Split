using System;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MortgagePlatform.API.DTOs;
using MortgagePlatform.API.Services;

namespace MortgagePlatform.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize(Roles = "Admin")]
    public class LoansController : ControllerBase
    {
        private readonly ILoanService _loanService;

        public LoansController(ILoanService loanService)
        {
            _loanService = loanService;
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetLoanApplication(int id)
        {
            var loanApplication = await _loanService.GetLoanApplicationByIdAsync(id);
            if (loanApplication == null)
            {
                return NotFound();
            }

            return Ok(loanApplication);
        }

        [HttpGet]
        public async Task<IActionResult> GetAllLoanApplications([FromQuery] int page = 1, [FromQuery] int limit = 10, [FromQuery] string status = "", [FromQuery] string search = "")
        {
            var loanApplications = await _loanService.GetAllLoanApplicationsWithPaginationAsync(page, limit, status, search);
            return Ok(loanApplications);
        }

        [HttpPut("{id}/status")]
        public async Task<IActionResult> UpdateLoanApplicationStatus(int id, [FromBody] UpdateLoanApplicationStatusDto dto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            try
            {
                var result = await _loanService.UpdateLoanApplicationStatusAsync(id, dto);
                return Ok(result);
            }
            catch (ArgumentException ex)
            {
                return NotFound(new { message = ex.Message });
            }
        }
    }
}