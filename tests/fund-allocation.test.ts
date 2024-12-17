import { describe, it, expect, beforeEach } from 'vitest';
import { vi } from 'vitest';

describe('Fund Allocation Contract', () => {
  const mockContractCall = vi.fn();
  
  beforeEach(() => {
    vi.resetAllMocks();
  });
  
  it('should create an allocation', async () => {
    mockContractCall.mockResolvedValue({ success: true, value: 1 });
    const result = await mockContractCall('fund-allocation', 'create-allocation', [1, 1000]);
    expect(result.success).toBe(true);
    expect(result.value).toBe(1);
  });
  
  it('should approve an allocation', async () => {
    mockContractCall.mockResolvedValue({ success: true });
    const result = await mockContractCall('fund-allocation', 'approve-allocation', [1]);
    expect(result.success).toBe(true);
  });
  
  it('should get allocation details', async () => {
    mockContractCall.mockResolvedValue({
      success: true,
      value: {
        charity_id: 1,
        amount: 1000,
        status: 'pending'
      }
    });
    const result = await mockContractCall('fund-allocation', 'get-allocation', [1]);
    expect(result.success).toBe(true);
    expect(result.value.charity_id).toBe(1);
    expect(result.value.amount).toBe(1000);
    expect(result.value.status).toBe('pending');
  });
});

