import { Router, Request, Response } from 'express';
import getSupabase from '../config/supabase';
import { config } from '../config';
import jwt from 'jsonwebtoken';

const sb = getSupabase();

const router = Router();

// POST /api/auth/register
router.post('/register', async (req: Request, res: Response) => {
  try {
    const { email, password, name, role, class_name } = req.body;
    if (!email || !password || !name || !role) {
      return res.status(400).json({ success: false, error: 'Missing required fields' });
    }

    const { data: authData, error: authError } = await sb.auth.signUp({
      email,
      password,
    });

    if (authError) {
      return res.status(400).json({ success: false, error: authError.message });
    }

    const user = authData.user;
    if (!user) {
      return res.status(500).json({ success: false, error: 'Failed to create user' });
    }

    // Insert into public users table
    const { data: profile, error: profileError } = await sb
      .from('users')
      .insert({ id: user.id, email, name, role, class_name })
      .select()
      .single();

    if (profileError) {
      return res.status(500).json({ success: false, error: profileError.message });
    }

    // Generate JWT
    const token = jwt.sign(
      { userId: profile.id, email: profile.email, role: profile.role },
      config.jwt.secret,
      { expiresIn: config.jwt.expiresIn as any }
    );

    res.status(201).json({ success: true, data: { user: profile, token } });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// POST /api/auth/login
router.post('/login', async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ success: false, error: 'Email and password required' });
    }

    const { data: authData, error: authError } = await sb.auth.signInWithPassword({
      email,
      password,
    });

    if (authError) {
      return res.status(401).json({ success: false, error: 'Invalid credentials' });
    }

    const { data: profile, error: profileError } = await sb
      .from('users')
      .select()
      .eq('id', authData.user.id)
      .single();

    if (profileError || !profile) {
      return res.status(500).json({ success: false, error: 'Profile not found' });
    }

    const token = jwt.sign(
      { userId: profile.id, email: profile.email, role: profile.role },
      config.jwt.secret,
      { expiresIn: config.jwt.expiresIn as any }
    );

    res.json({ success: true, data: { user: profile, token } });
  } catch (err: any) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// GET /api/auth/me
router.get('/me', async (req: Request, res: Response) => {
  try {
    const header = req.headers.authorization;
    if (!header || !header.startsWith('Bearer ')) {
      return res.status(401).json({ success: false, error: 'No token' });
    }

    const token = header.split(' ')[1];
    const decoded = jwt.verify(token, config.jwt.secret) as { userId: string };

    const { data: user, error } = await sb
      .from('users')
      .select()
      .eq('id', decoded.userId)
      .single();

    if (error || !user) {
      return res.status(404).json({ success: false, error: 'User not found' });
    }

    res.json({ success: true, data: user });
  } catch (err: any) {
    res.status(401).json({ success: false, error: 'Invalid token' });
  }
});

export default router;
