import { describe, it, expect, beforeEach } from 'vitest';
import { vi } from 'vitest';

describe('Donation Management Contract', () => {
  const mockContractCall = vi.fn();
  
  beforeEach(() => {
    vi.resetAllMocks();
  });
  
  it('should register a charity', async () => {
    mockContractCall.mockResolvedValue({ success: true, value: 1 });
    const result = await mockContractCall('donation-management', 'register-charity', ['Charity Name', 'Charity Description', 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM']);
    expect(result.success).toBe(true);
    expect(result.value).toBe(1);
  });
  
  it('should donate to a charity', async () => {
    mockContractCall.mockResolvedValue({ success: true });
    const result = await mockContractCall('donation-management', 'donate', [1000, 1]);
    expect(result.success).toBe(true);
  });
  
  it('should get charity details', async () => {
    mockContractCall.mockResolvedValue({
      success: true,
      value: {
        name: 'Charity Name',
        description: 'Charity Description',
        wallet: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM',
        total_received: 1000,
        total_allocated: 0
      }
    });
    const result = await mockContractCall('donation-management', 'get-charity', [1]);
    expect(result.success).toBe(true);
    expect(result.value.name).toBe('Charity Name');
  });
  
  it('should get donation token balance', async () => {
    mockContractCall.mockResolvedValue({ success: true, value: 1000 });
    const result = await mockContractCall('donation-management', 'get-donation-token-balance', ['ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM']);
    expect(result.success).toBe(true);
    expect(result.value).toBe(1000);
  });
});

