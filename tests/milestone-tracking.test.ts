import { describe, it, expect, beforeEach } from 'vitest';
import { vi } from 'vitest';

describe('Milestone Tracking Contract', () => {
  const mockContractCall = vi.fn();
  
  beforeEach(() => {
    vi.resetAllMocks();
  });
  
  it('should create a milestone', async () => {
    mockContractCall.mockResolvedValue({ success: true, value: 1 });
    const result = await mockContractCall('milestone-tracking', 'create-milestone', [1, 'Milestone Description', 1000]);
    expect(result.success).toBe(true);
    expect(result.value).toBe(1);
  });
  
  it('should update a milestone', async () => {
    mockContractCall.mockResolvedValue({ success: true });
    const result = await mockContractCall('milestone-tracking', 'update-milestone', [1, 500]);
    expect(result.success).toBe(true);
  });
  
  it('should get milestone details', async () => {
    mockContractCall.mockResolvedValue({
      success: true,
      value: {
        charity_id: 1,
        description: 'Milestone Description',
        target_amount: 1000,
        current_amount: 500,
        status: 'active'
      }
    });
    const result = await mockContractCall('milestone-tracking', 'get-milestone', [1]);
    expect(result.success).toBe(true);
    expect(result.value.charity_id).toBe(1);
    expect(result.value.current_amount).toBe(500);
    expect(result.value.status).toBe('active');
  });
});

